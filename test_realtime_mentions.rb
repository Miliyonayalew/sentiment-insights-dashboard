#!/usr/bin/env ruby

# Test script to verify the real-time mentions feature
# Run this script to test the complete flow

require_relative 'config/environment'

puts "🚀 Testing Real-time Mentions Feature"
puts "=" * 50

# Create a test user if needed
user = User.find_or_create_by(email: 'test@example.com') do |u|
  u.password = 'password123'
  u.password_confirmation = 'password123'
  u.name = 'Test User'
end

puts "✅ Test user created/found: #{user.email}"

# Create a test keyword
keyword = user.tracked_keywords.find_or_create_by(keyword: 'technology')
puts "✅ Test keyword created/found: #{keyword.keyword}"

# Test the broadcasting
puts "\n📡 Testing ActionCable broadcast..."

# Simulate the job completion broadcast
test_mentions = [
  {
    id: 1,
    title: "Test Tech Article",
    content: "This is a test technology article",
    url: "https://example.com/test",
    source: "Test Source",
    published_at: Time.current,
    sentiment: "positive",
    created_at: Time.current
  }
]

ActionCable.server.broadcast(
  "mentions:#{user.id}",
  {
    type: 'mentions_fetched',
    keyword_id: keyword.id,
    keyword: keyword.keyword,
    new_mentions_count: 1,
    mentions: test_mentions
  }
)

puts "✅ Test broadcast sent to user: #{user.email}"

# Test job manually
puts "\n⚙️  Testing FetchMentionsJob..."
begin
  FetchMentionsJob.perform_now(keyword.id)
  puts "✅ Job executed successfully"
rescue => e
  puts "❌ Job failed: #{e.message}"
  puts "Note: This might fail if NEWS_API_KEY is not configured"
end

puts "\n📊 Current mentions count: #{keyword.mentions.count}"

puts "\n" + "=" * 50
puts "🎉 Test completed!"
puts "\nTo test the full real-time flow:"
puts "1. Start the Rails server: bin/rails server"
puts "2. Start Sidekiq: bundle exec sidekiq"
puts "3. Connect a WebSocket client to: ws://localhost:3000/cable"
puts "4. Make a POST request to: /api/v1/tracked_keywords/#{keyword.id}/fetch_mentions"
puts "5. Watch for real-time updates via WebSocket"
