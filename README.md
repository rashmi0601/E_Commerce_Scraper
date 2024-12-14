 # ECommerce Scraper

This project is an e-commerce scraping application built using Ruby on Rails. It enables users to scrape product data from various e-commerce websites, store the data in a database, and view the data categorized by product categories. The application supports asynchronous scraping using Sidekiq and Redis, and features an automated mechanism to refetch outdated product data (older than one week).

# Features

* Core Features

  - Scrape Product Data: Users can input a product URL to scrape relevant details such as title, description, price, size, and category.

  - Search Products: A search functionality allows users to find products by title.

  - Categorized Display: Products are displayed under their respective categories.

* Advanced Features

  - Asynchronous Scraping: Scraping is handled asynchronously to ensure the user experience is not blocked.

  - Automatic Refetch: Automatically refetches and updates product data if it is older than one week.

  - Error Handling: Displays error messages to users when scraping fails.

  - Admin Dashboard: Includes an admin interface to view and manage Sidekiq jobs (via /sidekiq).

# Installation

* Prerequisites

  - Ruby: Version 3.1+

  - Rails: Version 6+
  
  - PostgreSQL: As the database.

  - Redis: For job queuing (required by Sidekiq).

  - Bundler: To install Ruby gems.
 
# Setup Steps

* Clone the Repository:
```
  git clone <repository_url>
  cd e_commerce_scraper
```
* Install Dependencies:
```
bundle install
```
* Set Up the Database:
```
rails db:create db:migrate db:seed
```
* Configure Redis:
  - Ensure Redis is installed and running on your machine. Start Redis using:
```
redis-server
```

* Start the Application:
  - In separate terminal tabs, run the following commands:

  - Start Rails Server:
```
rails server
```
* Start Sidekiq:
```
bundle exec sidekiq
```
* Access the Application:
```
Open http://localhost:3000 in your web browser.
```
* Access Sidekiq Dashboard:
```
Visit http://localhost:3000/sidekiq
```
# Usage

* Scraping a Product

  - Navigate to the homepage.

  - Enter the product URL into the input field and click Scrape Product.

  - A notice will indicate that scraping is in progress.

* Searching for Products

  - Use the search bar to search for products by title.

  - Matching products will be displayed along with their categories.

# Configuration

* Environment Variables

  - Set up the following environment variables in .env or in your system environment:
```
SCRAPER_API_KEY=your_scraperapi_key
```

# Technologies Used

* Ruby on Rails: Web application framework.

* PostgreSQL: Database.

* Redis: Job queue management.

* Sidekiq: Background job processing.

* Nokogiri: HTML parsing and scraping.

* ScraperAPI: Proxy API for handling scraping.

* Rspec: Testing framework.

* FactoryBot:  For creating test data.

* SimpleCov: Code coverage analysis tool

# Known Issues and Future Enhancements

* Known Issues

  - Dynamic Selectors: If the CSS selectors for product data differ across websites, scraping may fail. The scraper needs to be adapted for each website’s structure.

  - Rate Limits: Ensure ScraperAPI's rate limits are not exceeded.

  - Supported URL: This is only a sample project and currently works only for Flipkart URLs.

* Future Enhancements

  - Advanced Parsing: Implement an AI-based parser to handle dynamic CSS selectors.

  - UI Improvements: Enhance the UI for better usability.

  - Notifications: Add  notifications for completed scraping tasks.

