# Real-time Mentions Feature

This feature provides real-time updates when mentions are fetched for tracked keywords using ActionCable WebSockets.

## How It Works

1. **API Endpoint**: POST `/api/v1/tracked_keywords/:id/fetch_mentions` queues a background job
2. **Background Job**: `FetchMentionsJob` fetches mentions and broadcasts results via ActionCable
3. **Real-time Updates**: Connected WebSocket clients receive instant notifications when jobs complete

## Setup & Running Instructions

### Prerequisites
- Redis server running (for Sidekiq)
- PostgreSQL database
- Environment variables configured (NEWS_API_KEY, etc.)

### Development Setup

1. **Start Redis** (required for Sidekiq):
```bash
# On Ubuntu/Debian:
sudo systemctl start redis-server

# On macOS with Homebrew:
brew services start redis

# Or run directly:
redis-server
```

2. **Start the Rails application**:
```bash
# Terminal 1 - Rails server with ActionCable
bin/rails server
```

3. **Start Sidekiq** (required for background jobs):
```bash
# Terminal 2 - Sidekiq worker
bundle exec sidekiq
```

4. **Optional: Start Sidekiq Web UI**:
```bash
# Access at http://localhost:3000/sidekiq
# Login with ADMIN_USER and ADMIN_PASSWORD env vars
```

### Testing the Feature

1. **Run the test script**:
```bash
ruby test_realtime_mentions.rb
```

2. **Manual API Testing**:
```bash
# Create a keyword (requires authentication)
curl -X POST http://localhost:3000/api/v1/tracked_keywords \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"tracked_keyword": {"keyword": "technology"}}'

# Start fetching mentions (will trigger real-time updates)
curl -X POST http://localhost:3000/api/v1/tracked_keywords/1/fetch_mentions \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

3. **WebSocket Connection Test**:
```javascript
// Connect to ActionCable
const cable = ActionCable.createConsumer('ws://localhost:3000/cable?token=YOUR_JWT_TOKEN');

// Subscribe to mentions channel
const subscription = cable.subscriptions.create("MentionsChannel", {
  received(data) {
    console.log("Real-time update:", data);
  }
});
```

## API Endpoints

### Fetch Mentions
```
POST /api/v1/tracked_keywords/:id/fetch_mentions
Authorization: Bearer JWT_TOKEN

Response:
{
  "message": "Fetching mentions started.",
  "job_id": "12345",
  "keyword": "technology"
}
```

### Get Mentions
```
GET /api/v1/tracked_keywords/:id/mentions
Authorization: Bearer JWT_TOKEN

Response: [array of mention objects]
```

### Get Status
```
GET /api/v1/tracked_keywords/:id/status
Authorization: Bearer JWT_TOKEN

Response:
{
  "keyword_id": 1,
  "keyword": "technology",
  "mentions_count": 15,
  "last_updated": "2025-06-12T10:30:00Z"
}
```

## WebSocket Messages

### Job Started
```json
{
  "type": "fetch_started",
  "keyword_id": 1,
  "keyword": "technology",
  "job_id": "12345"
}
```

### Job Completed
```json
{
  "type": "mentions_fetched",
  "keyword_id": 1,
  "keyword": "technology",
  "new_mentions_count": 5,
  "mentions": [
    {
      "id": 1,
      "title": "Tech News Article",
      "content": "Article description...",
      "url": "https://example.com/article",
      "source": "TechCrunch",
      "published_at": "2025-06-12T10:00:00Z",
      "sentiment": "positive",
      "created_at": "2025-06-12T10:30:00Z"
    }
  ]
}
```

### Job Error
```json
{
  "type": "fetch_error",
  "keyword_id": 1,
  "error": "API rate limit exceeded"
}
```

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Rails API      │    │   Background    │
│   (WebSocket)   │◄──►│   (ActionCable)  │◄──►│   Jobs          │
└─────────────────┘    └──────────────────┘    │   (Sidekiq)     │
                                │               └─────────────────┘
                                ▼
                       ┌──────────────────┐
                       │   Database       │
                       │   (PostgreSQL)   │
                       └──────────────────┘
```

## Troubleshooting

### Common Issues

1. **WebSocket Connection Fails**:
   - Ensure ActionCable is mounted in routes: `mount ActionCable.server => '/cable'`
   - Check CORS settings in development.rb
   - Verify JWT token is valid and passed correctly

2. **Background Jobs Not Processing**:
   - Ensure Sidekiq is running: `bundle exec sidekiq`
   - Check Redis connection: `redis-cli ping`
   - Verify job queue configuration

3. **No Real-time Updates**:
   - Check browser console for WebSocket errors
   - Verify user authentication in ActionCable connection
   - Ensure MentionsChannel broadcasting is working

### Debug Commands

```bash
# Check Redis connection
redis-cli ping

# Check Sidekiq queues
bundle exec sidekiq-cron

# Check ActionCable in Rails console
rails console
> ActionCable.server.broadcast("mentions:user_1", {test: "message"})

# Check database connections
rails console
> ActiveRecord::Base.connection.active?
```

## Production Deployment

1. **Configure ActionCable origins** in `config/environments/production.rb`
2. **Set up SSL** for WebSocket connections (wss://)
3. **Configure Redis** for ActionCable in production
4. **Set environment variables** for authentication and API keys
5. **Deploy with process manager** (systemd, Docker, etc.) to run both Rails and Sidekiq

## Security Considerations

- JWT tokens are validated for WebSocket connections
- CORS origins are restricted in production
- Rate limiting should be implemented for job creation
- Input validation on all API endpoints
