class FetchMentionsJob < ApplicationJob
  queue_as :default

  def perform(tracked_keyword_id, page_size = 20)
    keyword = TrackedKeyword.find(tracked_keyword_id)
    user = keyword.user

    # Use the provided page_size parameter
    articles = NewsApiClient.new.fetch_articles(keyword.keyword, page_size)

    new_mentions = []
    articles.each do |article|
      next if keyword.mentions.exists?(url: article["url"]) # avoid duplicates

      # Check if keyword appears in title or description (case-insensitive)
      search_term = keyword.keyword.downcase
      title = article["title"]&.downcase || ""
      description = article["description"]&.downcase || ""

      # Skip if keyword is not in title or description
      unless title.include?(search_term) || description.include?(search_term)
        Rails.logger.info "Skipping irrelevant article: '#{article['title']}' for keyword '#{keyword.keyword}'"
        next
      end

      # Analyze both title and description for better sentiment detection
      combined_text = "#{article['title']} #{article['description']}".strip

      # Use the correct VaderSentimentRuby syntax
      sentiment_scores = VaderSentimentRuby.polarity_scores(combined_text)
      Rails.logger.info "Sentiment scores for '#{article['title']}': #{sentiment_scores.inspect}"

      sentiment = sentiment_scores[:compound]
      Rails.logger.info "Raw compound sentiment: #{sentiment} (#{sentiment.class})"
      sentiment = sentiment.to_f

      sentiment_label = if sentiment < -0.05
                          "negative"
      elsif sentiment > 0.05
                          "positive"
      else
                          "neutral"
      end
      Rails.logger.info "Classified as '#{sentiment_label}' (compound: #{sentiment})"


      mention = keyword.mentions.create!(
        title: article["title"],
        content: article["description"],
        url: article["url"],
        source: article["source"]["name"],
        published_at: article["publishedAt"],
        sentiment: sentiment_label
      )

      new_mentions << mention
    end

    # Broadcast the results to the user via ActionCable
    ActionCable.server.broadcast(
      "mentions:#{user.id}",
      {
        type: "mentions_fetched",
        keyword_id: keyword.id,
        keyword: keyword.keyword,
        new_mentions_count: new_mentions.count,
        mentions: new_mentions.map do |mention|
          {
            id: mention.id,
            title: mention.title,
            content: mention.content,
            url: mention.url,
            source: mention.source,
            published_at: mention.published_at,
            sentiment: mention.sentiment,
            created_at: mention.created_at
          }
        end
      }
    )

    Rails.logger.info "FetchMentionsJob completed: #{new_mentions.count} new mentions for keyword '#{keyword.keyword}'"
  rescue => e
    Rails.logger.error "FetchMentionsJob failed: #{e.message}"

    # Broadcast error to user
    user = TrackedKeyword.find(tracked_keyword_id).user rescue nil
    if user
      ActionCable.server.broadcast(
        "mentions:#{user.id}",
        {
          type: "fetch_error",
          keyword_id: tracked_keyword_id,
          error: e.message
        }
      )
    end

    raise e
  end
end
