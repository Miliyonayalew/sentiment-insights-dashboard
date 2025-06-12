#!/usr/bin/env ruby

# This script recalculates sentiment for existing mentions
# Run with: ruby recalculate_sentiments.rb

require_relative 'config/environment'

puts "🔄 Recalculating sentiments for existing mentions..."
puts "=" * 50

total = Mention.count
updated = 0
neutral_before = Mention.where(sentiment: 'neutral').count
positive_before = Mention.where(sentiment: 'positive').count
negative_before = Mention.where(sentiment: 'negative').count

Mention.find_each do |mention|
  # Combine title and content for better sentiment analysis
  combined_text = "#{mention.title} #{mention.content}".strip

  # Skip if empty text
  next if combined_text.blank?

  # Get sentiment scores
  sentiment_scores = VaderSentimentRuby.polarity_scores(combined_text)
  sentiment = sentiment_scores['compound'] || 0

  # Use more relaxed thresholds for better sentiment classification
  new_sentiment = sentiment > 0.03 ? 'positive' : sentiment < -0.03 ? 'negative' : 'neutral'

  # Only update if sentiment changed
  if mention.sentiment != new_sentiment
    old_sentiment = mention.sentiment
    mention.update(sentiment: new_sentiment)
    updated += 1
    puts "Updated: \"#{mention.title[0..50]}...\" from #{old_sentiment} to #{new_sentiment} (score: #{sentiment.round(3)})"
  end
end

# Get new counts
neutral_after = Mention.where(sentiment: 'neutral').count
positive_after = Mention.where(sentiment: 'positive').count
negative_after = Mention.where(sentiment: 'negative').count

puts "\n=" * 50
puts "📊 Sentiment Distribution Summary"
puts "=" * 50
puts "BEFORE:"
puts "  Positive: #{positive_before} (#{(positive_before.to_f / total * 100).round(1)}%)"
puts "  Neutral:  #{neutral_before} (#{(neutral_before.to_f / total * 100).round(1)}%)"
puts "  Negative: #{negative_before} (#{(negative_before.to_f / total * 100).round(1)}%)"
puts "\nAFTER:"
puts "  Positive: #{positive_after} (#{(positive_after.to_f / total * 100).round(1)}%)"
puts "  Neutral:  #{neutral_after} (#{(neutral_after.to_f / total * 100).round(1)}%)"
puts "  Negative: #{negative_after} (#{(negative_after.to_f / total * 100).round(1)}%)"
puts "\nUpdated #{updated} out of #{total} mentions."
puts "=" * 50
