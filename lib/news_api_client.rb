require 'httparty'

class NewsApiClient
  include HTTParty
  base_uri 'https://newsapi.org/v2'

  def initialize(api_key = ENV['NEWS_API_KEY'])
    @api_key = api_key
  end

  def fetch_articles(keyword)
    self.class.get('/everything', query: {
      q: keyword,
      language: 'en',
      sortBy: 'publishedAt',
      apiKey: @api_key,
      pageSize: 10
    })['articles']
  end
end
