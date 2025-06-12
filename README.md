<a name="readme-top"></a>

<!--
!!! IMPORTANT !!!
This README is an example of how you could professionally present your codebase. 
Writing documentation is a crucial part of your work as a professional software developer and cannot be ignored. 

You should modify this file to match your project and remove sections that don't apply.

REQUIRED SECTIONS:
- Table of Contents
- About the Project
  - Built With
  - Live Demo
- Getting Started
- Authors
- Future Features
- Contributing
- Show your support
- Acknowledgements
- License

OPTIONAL SECTIONS:
- FAQ

After you're finished please remove all the comments and instructions!

For more information on the importance of a professional README for your repositories: https://github.com/microverseinc/curriculum-transversal-skills/blob/main/documentation/articles/readme_best_practices.md
-->

<div align="center">
  <img src="murple_logo.png" alt="logo" width="140"  height="auto" />
  <br/>

  <h3><b>Social Media Sentiment Dashboard</b></h3>

</div>

<!-- TABLE OF CONTENTS -->

# 📗 Table of Contents

- [📗 Table of Contents](#-table-of-contents)
- [📖 Social Media Sentiment Dashboard](#-social-media-sentiment-dashboard-)
  - [🛠 Built With](#-built-with-)
    - [Tech Stack](#tech-stack-)
    - [Key Features](#key-features-)
  - [🚀 Live Demo](#-live-demo-)
  - [💻 Getting Started](#-getting-started-)
    - [Prerequisites](#prerequisites)
    - [Setup](#setup)
    - [Install](#install)
    - [Usage](#usage)
    - [🔧 Background Jobs & Process Management](#-background-jobs--process-management-)
    - [Run tests](#run-tests)
    - [Deployment](#deployment)
  - [👥 Authors](#-authors-)
  - [🔭 Future Features](#-future-features-)
  - [🤝 Contributing](#-contributing-)
  - [⭐️ Show your support](#️-show-your-support-)
  - [🙏 Acknowledgments](#-acknowledgments-)
  - [❓ FAQ](#-faq-)
  - [📝 License](#-license-)

<!-- PROJECT DESCRIPTION -->

# 📖 Social Media Sentiment Dashboard <a name="about-project"></a>

> A real-time social media sentiment analysis dashboard that tracks keywords and analyzes public sentiment using news articles.

**Social Media Sentiment Dashboard** is a Ruby on Rails API application that allows users to track specific keywords, fetch related news mentions from various sources, perform sentiment analysis, and receive real-time updates through WebSocket connections. The application provides comprehensive sentiment insights for brands, topics, or any keywords of interest.

## 🛠 Built With <a name="built-with"></a>

### Tech Stack <a name="tech-stack"></a>

> Describe the tech stack and include only the relevant sections that apply to your project.

<details>
  <summary>Client</summary>
  <ul>
    <li><a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript">JavaScript</a></li>
    <li><a href="https://developer.mozilla.org/en-US/docs/Web/Guide/AJAX">AJAX</a></li>
    <li><a href="https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API">WebSockets</a></li>
  </ul>
</details>

<details>
  <summary>Server</summary>
  <ul>
    <li><a href="https://rubyonrails.org/">Ruby on Rails 8.0.2</a></li>
    <li><a href="https://github.com/rails/rails/tree/main/actioncable">Action Cable</a></li>
    <li><a href="https://github.com/mperham/sidekiq">Sidekiq</a></li>
  </ul>
</details>

<details>
<summary>Database</summary>
  <ul>
    <li><a href="https://www.postgresql.org/">PostgreSQL</a></li>
    <li><a href="https://redis.io/">Redis</a></li>
  </ul>
</details>

<details>
<summary>External APIs & Services</summary>
  <ul>
    <li><a href="https://newsapi.org/">News API</a></li>
    <li><a href="https://github.com/jonatas/vader_sentiment_ruby">VADER Sentiment Analysis</a></li>
  </ul>
</details>

<!-- Features -->

### Key Features <a name="key-features"></a>

> Core functionality of the sentiment analysis dashboard.

- **Real-time Keyword Tracking** - Track multiple keywords and get instant notifications
- **Sentiment Analysis** - Advanced sentiment analysis using VADER algorithm with customizable thresholds
- **Background Job Processing** - Efficient background processing with Sidekiq for scalable mention fetching
- **Live WebSocket Updates** - Real-time updates via Action Cable for immediate feedback
- **News API Integration** - Fetch relevant articles from multiple news sources
- **User Authentication** - Secure JWT-based authentication with Devise
- **RESTful API** - Clean API endpoints for all operations
- **Duplicate Prevention** - Smart filtering to avoid duplicate mentions
- **Relevance Filtering** - Advanced filtering to ensure keyword relevance in fetched content

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LIVE DEMO -->

## 🚀 Live Demo <a name="live-demo"></a>

> The application is currently in development. A live demo will be available soon.

- [Live Demo Link](https://github.com/yourusername/social-media-sentiment-dashboard) - Coming Soon
- [API Documentation](http://localhost:3000/sidekiq) - Sidekiq Web UI (when running locally)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## 💻 Getting Started <a name="getting-started"></a>

> Follow these steps to get the Social Media Sentiment Dashboard running on your local machine.

To get a local copy up and running, follow these steps.

### Prerequisites

In order to run this project you need:

```sh
# Ruby 3.4.4 or higher
ruby --version

# Rails 8.0.2 or higher  
rails --version

# PostgreSQL
psql --version

# Redis server
redis-server --version

# Node.js (for asset compilation)
node --version
```

### Setup

Clone this repository to your desired folder:

```sh
cd my-folder
git clone git@github.com:yourusername/social-media-sentiment-dashboard.git
cd social-media-sentiment-dashboard
```

### Install

Install this project with:

```sh
# Install Ruby dependencies
bundle install

# Setup the database
rails db:create
rails db:migrate
rails db:seed

# Start Redis server (if not already running)
redis-server
```

### Environment Variables

Create a `.env` file in the root directory and add:

```sh
# News API Key (get from https://newsapi.org)
NEWS_API_KEY=your_news_api_key_here

# Sidekiq Web UI credentials (optional)
ADMIN_USER=admin
ADMIN_PASSWORD=password

# Database configuration (if needed)
DATABASE_URL=postgres://username:password@localhost/social_media_sentiment_dashboard_development
```

### Usage

To run the project, execute the following command:

#### 🔧 Background Jobs & Process Management <a name="background-jobs-process-management"></a>

**🎉 No More Manual Sidekiq Starting!**

**Before:** You had to run `bundle exec sidekiq` manually every time  
**After:** Just run `./bin/dev` and both Rails and Sidekiq start automatically

#### For Development:

**Option 1: Automatic Process Management (Recommended)**
```sh
# Start both Rails server and Sidekiq automatically
./bin/dev

# This runs:
# - Rails server on http://localhost:5000
# - Sidekiq worker in the background
# - Uses Foreman for process management
```

**Option 2: Alternative Auto-Start Script**
```sh
# Start with automatic service management
./bin/dev-auto

# This script:
# - Checks if Redis is running
# - Starts Sidekiq automatically if not running  
# - Starts Rails server
# - Handles cleanup on exit
```

**Option 3: Manual Control (Not Recommended)**
```sh
# Terminal 1: Start Sidekiq
bundle exec sidekiq

# Terminal 2: Start Rails server
rails server
```

#### Key Improvements:

✅ **Automatic startup** - No more forgetting to start Sidekiq  
✅ **Better error messages** - API tells you if Sidekiq is down  
✅ **Process management** - Foreman handles both services  
✅ **Graceful shutdown** - Properly stops both services when you exit

#### For Production:

You would typically use a process manager like:

- **systemd** (Linux)
- **Docker Compose** 
- **Kubernetes**
- **Heroku** (uses Procfile automatically)

#### Service Status Monitoring:

```sh
# Check what's running
ps aux | grep -E "(redis|sidekiq|rails)" | grep -v grep

# Access Sidekiq Web UI
open http://localhost:3000/sidekiq
```

**Issue resolved!** 🎉 Your background jobs will now work automatically without manual intervention.

### Run tests

To run tests, run the following command:

```sh
# Run all tests
rails test

# Run specific test files
rails test test/models/mention_test.rb
rails test test/controllers/api/v1/tracked_keywords_controller_test.rb
rails test test/jobs/fetch_mentions_job_test.rb

# Run tests with coverage
rails test --verbose
```

### Deployment

You can deploy this project using:

#### Heroku Deployment:
```sh
# Login to Heroku
heroku login

# Create app
heroku create your-app-name

# Add PostgreSQL and Redis
heroku addons:create heroku-postgresql:mini
heroku addons:create heroku-redis:mini

# Set environment variables
heroku config:set NEWS_API_KEY=your_api_key
heroku config:set ADMIN_USER=admin
heroku config:set ADMIN_PASSWORD=secure_password

# Deploy
git push heroku main

# Run migrations
heroku run rails db:migrate
```

#### Docker Deployment:
```sh
# Build and run with Docker Compose
docker-compose up --build

# Or build manually
docker build -t sentiment-dashboard .
docker run -p 3000:3000 sentiment-dashboard
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- AUTHORS -->

## 👥 Authors <a name="authors"></a>

> The contributors to this Social Media Sentiment Dashboard project.

👤 **Your Name**

- GitHub: [@yourusername](https://github.com/yourusername)
- Twitter: [@yourtwitterhandle](https://twitter.com/yourtwitterhandle) 
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/yourlinkedinhandle)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FUTURE FEATURES -->

## 🔭 Future Features <a name="future-features"></a>

> Planned enhancements for the Social Media Sentiment Dashboard.

- [ ] **Social Media Platform Integration** - Add Twitter, Facebook, Instagram APIs
- [ ] **Advanced Analytics Dashboard** - Interactive charts and sentiment trends
- [ ] **Email/SMS Notifications** - Alert system for sentiment threshold breaches
- [ ] **Machine Learning Improvements** - Custom sentiment models for specific industries
- [ ] **Multi-language Support** - Sentiment analysis for non-English content
- [ ] **Export Functionality** - PDF/CSV reports generation
- [ ] **Team Collaboration** - Multi-user workspaces and shared dashboards

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## 🤝 Contributing <a name="contributing"></a>

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](../../issues/).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- SUPPORT -->

## ⭐️ Show your support <a name="support"></a>

> If you find this Social Media Sentiment Dashboard helpful, please consider supporting the project.

If you like this project, please give it a ⭐️ on GitHub and share it with others who might find it useful for their sentiment analysis needs!

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGEMENTS -->

## 🙏 Acknowledgments <a name="acknowledgements"></a>

> Special thanks to the technologies and resources that made this project possible.

I would like to thank:

- [News API](https://newsapi.org/) for providing comprehensive news data
- [VADER Sentiment Analysis](https://github.com/jonatas/vader_sentiment_ruby) for the sentiment analysis algorithm
- [Sidekiq](https://sidekiq.org/) for reliable background job processing
- [Rails Community](https://rubyonrails.org/) for the excellent framework and documentation
- [Foreman](https://github.com/ddollar/foreman) for process management solutions

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FAQ (optional) -->

## ❓ FAQ <a name="faq"></a>

> Frequently asked questions about the Social Media Sentiment Dashboard.

- **How do I get a News API key?**

  - Visit [newsapi.org](https://newsapi.org/), create a free account, and copy your API key to the `.env` file as `NEWS_API_KEY=your_key_here`

- **Why do I need to run Sidekiq?**

  - Sidekiq handles background jobs for fetching and processing mentions. Without it, the fetch mentions feature won't work. Use `./bin/dev` to start both Rails and Sidekiq automatically.

- **How accurate is the sentiment analysis?**

  - The system uses VADER sentiment analysis with customized thresholds (0.03 for positive, -0.03 for negative) for better sensitivity than default settings.

- **Can I track multiple keywords simultaneously?**

  - Yes! Each user can track multiple keywords, and the system processes them independently with real-time updates for each.

- **What news sources are supported?**

  - The application uses News API which aggregates from 80,000+ sources including major news outlets, blogs, and magazines worldwide.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## 📝 License <a name="license"></a>

This project is [MIT](./LICENSE) licensed.

_NOTE: we recommend using the [MIT license](https://choosealicense.com/licenses/mit/) - you can set it up quickly by [using templates available on GitHub](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/adding-a-license-to-a-repository). You can also use [any other license](https://choosealicense.com/licenses/) if you wish._

<p align="right">(<a href="#readme-top">back to top</a>)</p>
