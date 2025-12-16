# Magic Query

A Ruby gem that generates SQL SELECT queries from natural language using AI providers (OpenAI, Claude, Gemini).

## Features

- 🤖 Integration with OpenAI, Claude (Anthropic), and Google Gemini
- 📊 Automatic database schema loading from files or database connections
- ⚙️ Configurable rules and conventions via YAML files
- 🚂 Rails integration with optional controller and routes
- 🔒 SQL validation to prevent dangerous operations
- 🎯 Customizable prompts and AI parameters

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'magic_query'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install magic_query
```

## Usage

### Basic Usage

```ruby
require 'magic_query'

# Configure the gem
MagicQuery.configure do |config|
  config.provider = :openai
  config.api_key = ENV['MAGIC_QUERY_API_KEY']
  config.schema_path = 'config/schema.sql'
  config.rules_path = 'config/magic_query.yml'
end

# Generate a SQL query
generator = MagicQuery::QueryGenerator.new
sql = generator.generate("trova tutti gli utenti attivi")
# => "SELECT * FROM users WHERE status = 'active'"
```

### Rails Integration

1. Run the generator to install configuration files:

```bash
rails generate magic_query:install
```

This will create:
- `config/initializers/magic_query.rb` - Configuration file
- `config/magic_query.yml` - Rules and conventions file

2. Configure your API key and settings in `config/initializers/magic_query.rb`:

```ruby
MagicQuery.configure do |config|
  config.provider = :openai
  config.api_key = ENV['MAGIC_QUERY_API_KEY']
  config.schema_path = Rails.root.join('config', 'schema.sql').to_s
  config.rules_path = Rails.root.join('config', 'magic_query.yml').to_s
end
```

3. Use the controller endpoint (optional):

```ruby
# POST /magic_query/generate
# Body: { "query": "trova tutti gli utenti attivi" }
# Response: { "sql": "SELECT * FROM users WHERE status = 'active'", "query": "..." }
```

For detailed information about the controller, customization options, and how to override methods, see [CONTROLLER.md](CONTROLLER.md).

## Configuration

### Providers

#### OpenAI

```ruby
MagicQuery.configure do |config|
  config.provider = :openai
  config.api_key = ENV['MAGIC_QUERY_API_KEY']
  config.model = 'gpt-4o-mini' # Optional, defaults to gpt-4o-mini
end
```

#### Claude (Anthropic)

```ruby
MagicQuery.configure do |config|
  config.provider = :claude
  config.api_key = ENV['ANTHROPIC_API_KEY']
  config.model = 'claude-3-5-sonnet-20241022' # Optional
end
```

#### Gemini (Google)

```ruby
MagicQuery.configure do |config|
  config.provider = :gemini
  config.api_key = ENV['GEMINI_API_KEY']
  config.model = 'gemini-1.5-flash' # Optional
end
```

### Schema Configuration

#### From File

```ruby
config.schema_path = 'config/schema.sql'
```

The schema file can be:
- SQL file with CREATE TABLE statements
- YAML file with structured schema definition

#### From Database (Future)

```ruby
config.database_url = ENV['DATABASE_URL']
```

### Rules Configuration

Create a YAML file (`config/magic_query.yml`) with your database rules:

```yaml
naming_conventions:
  table_prefix: ''
  column_naming: 'snake_case'

relationships:
  - 'users has_many posts'
  - 'posts belongs_to users'

business_rules:
  - 'Active users have status = "active"'
  - 'Use soft deletes where applicable'

tables:
  users:
    description: 'User accounts table'
    important_columns:
      - 'id (primary key)'
      - 'email (unique, required)'
```

### AI Parameters

```ruby
config.temperature = 0.3  # Lower = more deterministic
config.max_tokens = 1000   # Maximum response length
config.base_prompt = 'Your custom prompt here' # Optional
```

## API Reference

### MagicQuery.configure

Configure the gem globally:

```ruby
MagicQuery.configure do |config|
  # Configuration options
end
```

### MagicQuery::QueryGenerator

Main class for generating SQL queries:

```ruby
generator = MagicQuery::QueryGenerator.new(config)
sql = generator.generate("user input string")
```

## Development

### Using Docker (Recommended)

This project includes Docker support for running tests and linting without requiring Ruby to be installed locally.

#### Setup

Build the Docker image:

```bash
docker-compose build
```

#### Running Tests

Run all tests:

```bash
docker-compose run --rm app bundle exec rspec
```

Run tests with coverage:

```bash
docker-compose run --rm app bundle exec rspec
```

#### Running Linter

Run RuboCop:

```bash
docker-compose run --rm app bundle exec rubocop
```

Auto-fix RuboCop offenses:

```bash
docker-compose run --rm app bundle exec rubocop -a
```

#### Running Rake Tasks

Run default task (tests + lint):

```bash
docker-compose run --rm app bundle exec rake
```

Run only tests:

```bash
docker-compose run --rm app bundle exec rake spec
```

Run only lint:

```bash
docker-compose run --rm app bundle exec rake rubocop
```

#### Interactive Shell

Open an interactive shell in the container:

```bash
docker-compose run --rm app bash
```

### Local Development

If you have Ruby installed locally, after checking out the repo, run:

```bash
bundle install
```

Run tests:

```bash
bundle exec rspec
```

Run linter:

```bash
bundle exec rubocop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gioggi/magic_query.

## License

The gem is available as open source under the terms of the [Apache License 2.0](LICENSE).

## Copyright

Copyright (c) 2026 Giovanni Esposito

