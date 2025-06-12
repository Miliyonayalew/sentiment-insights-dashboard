require 'httparty'

class NewsApiClient
  include HTTParty
  base_uri 'https://newsapi.org/v2'

  def initialize(api_key = ENV['NEWS_API_KEY'])
    @api_key = api_key
  end

  def fetch_articles(keyword, page_size = 20)
    response = self.class.get('/everything', query: {
      q: keyword,
      language: 'en',
      sortBy: 'publishedAt',
      apiKey: @api_key,
      pageSize: page_size,  # Now dynamic
      searchIn: 'title,description'  # Prioritize title and description matches
    })

    # Handle potential API errors
    if response.success?
      response['articles'] || []
    else
      Rails.logger.error "NewsAPI Error: #{response.code} - #{response.message}"
      []
    end
  rescue => e
    Rails.logger.error "NewsAPI Exception: #{e.message}"
    []
  end
end
