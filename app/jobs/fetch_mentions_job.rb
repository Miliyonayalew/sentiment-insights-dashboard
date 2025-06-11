class FetchMentionsJob < ApplicationJob
  queue_as :default

  def perform(tracked_keyword_id)
    keyword = TrackedKeyword.find(tracked_keyword_id)
    articles = NewsApiClient.new.fetch_articles(keyword.keyword)

    articles.each do |article|
      next if keyword.mentions.exists?(url: article['url']) # avoid duplicates

      sentiment = VaderSentiment::SentimentIntensityAnalyzer.polarity_scores(article['title'])['compound']
      sentiment_label = sentiment > 0 ? 'positive' : sentiment < 0 ? 'negative' : 'neutral'

      keyword.mentions.create!(
        title: article['title'],
        content: article['description'],
        url: article['url'],
        source: article['source']['name'],
        published_at: article['publishedAt'],
        sentiment: sentiment_label
      )
    end
  end
end
