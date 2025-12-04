# Magic Query Controller Documentation

## Overview

The `MagicQuery::Rails::MagicQueryController` provides a RESTful endpoint for generating SQL queries from natural language. It handles the conversion of user input into SQL queries using the configured AI provider.

## How It Works

1. The `generate` action receives a query parameter (either `:query` or `:input`)
2. The input is processed by the `QueryGenerator` to produce SQL
3. The SQL is returned as JSON along with the original query

## API Endpoint

### POST /magic_query/generate

Generates a SQL query from natural language input.

**Request:**
```json
{
  "query": "trova tutti gli utenti attivi"
}
```

or

```json
{
  "input": "trova tutti gli utenti attivi"
}
```

**Response (Success):**
```json
{
  "sql": "SELECT * FROM users WHERE status = 'active'",
  "query": "trova tutti gli utenti attivi"
}
```

**Response (Error):**
```json
{
  "error": "Query parameter is required"
}
```

Status codes:
- `200 OK` - Success
- `400 Bad Request` - Missing query parameter
- `422 Unprocessable Entity` - MagicQuery::Error (validation, parsing, etc.)
- `500 Internal Server Error` - Unexpected errors

## Request Examples

### cURL

```bash
# Basic request
curl -X POST http://localhost:3000/magic_query/generate \
  -H "Content-Type: application/json" \
  -d '{
    "query": "trova tutti gli utenti attivi"
  }'

# Using input parameter
curl -X POST http://localhost:3000/magic_query/generate \
  -H "Content-Type: application/json" \
  -d '{
    "input": "mostra i primi 10 ordini del mese corrente"
  }'
```

### HTTP Raw Request

```http
POST /magic_query/generate HTTP/1.1
Host: localhost:3000
Content-Type: application/json
Content-Length: 45

{
  "query": "trova tutti gli utenti attivi"
}
```

### JavaScript (Fetch API)

```javascript
const response = await fetch('/magic_query/generate', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    query: 'trova tutti gli utenti attivi'
  })
});

const data = await response.json();
console.log(data.sql); // "SELECT * FROM users WHERE status = 'active'"
```

### Ruby (Net::HTTP)

```ruby
require 'net/http'
require 'json'
require 'uri'

uri = URI('http://localhost:3000/magic_query/generate')
http = Net::HTTP.new(uri.host, uri.port)

request = Net::HTTP::Post.new(uri.path)
request['Content-Type'] = 'application/json'
request.body = {
  query: 'trova tutti gli utenti attivi'
}.to_json

response = http.request(request)
result = JSON.parse(response.body)
puts result['sql']
```

### Python (requests)

```python
import requests

response = requests.post(
    'http://localhost:3000/magic_query/generate',
    json={
        'query': 'trova tutti gli utenti attivi'
    }
)

data = response.json()
print(data['sql'])  # "SELECT * FROM users WHERE status = 'active'"
```

## OpenAPI/Swagger Schema

You can integrate this endpoint with OpenAPI documentation tools using the following schema:

```yaml
openapi: 3.0.0
info:
  title: Magic Query API
  version: 1.0.0
  description: API for generating SQL queries from natural language

paths:
  /magic_query/generate:
    post:
      summary: Generate SQL query from natural language
      description: Converts a natural language query into a SQL SELECT statement
      operationId: generateQuery
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - query
              properties:
                query:
                  type: string
                  description: Natural language query to convert to SQL
                  example: "trova tutti gli utenti attivi"
                input:
                  type: string
                  description: Alternative parameter name for the query (alias for query)
                  example: "mostra i primi 10 ordini"
              oneOf:
                - required: [query]
                - required: [input]
            examples:
              query_parameter:
                summary: Using query parameter
                value:
                  query: "trova tutti gli utenti attivi"
              input_parameter:
                summary: Using input parameter
                value:
                  input: "mostra i primi 10 ordini"
      responses:
        '200':
          description: Successful generation
          content:
            application/json:
              schema:
                type: object
                properties:
                  sql:
                    type: string
                    description: Generated SQL query
                    example: "SELECT * FROM users WHERE status = 'active'"
                  query:
                    type: string
                    description: Original input query
                    example: "trova tutti gli utenti attivi"
              examples:
                success:
                  summary: Successful response
                  value:
                    sql: "SELECT * FROM users WHERE status = 'active'"
                    query: "trova tutti gli utenti attivi"
        '400':
          description: Bad request - missing query parameter
          content:
            application/json:
              schema:
                type: object
                properties:
                  error:
                    type: string
                    example: "Query parameter is required"
              examples:
                missing_parameter:
                  summary: Missing query parameter
                  value:
                    error: "Query parameter is required"
        '422':
          description: Unprocessable entity - MagicQuery validation error
          content:
            application/json:
              schema:
                type: object
                properties:
                  error:
                    type: string
                    example: "Invalid query format"
              examples:
                validation_error:
                  summary: Validation error
                  value:
                    error: "The generated SQL query contains forbidden operations"
        '500':
          description: Internal server error
          content:
            application/json:
              schema:
                type: object
                properties:
                  error:
                    type: string
                    example: "An error occurred: Connection timeout"
              examples:
                server_error:
                  summary: Server error
                  value:
                    error: "An error occurred: Connection timeout"
```

### Integration with rswag (RSpec Swagger)

If you're using `rswag` for OpenAPI documentation in Rails, you can add this to your spec:

```ruby
# spec/swagger_helper.rb or spec/requests/magic_query_spec.rb
require 'swagger_helper'

RSpec.describe 'Magic Query API', type: :request do
  path '/magic_query/generate' do
    post 'Generate SQL query' do
      tags 'Magic Query'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :query, in: :body, schema: {
        type: :object,
        properties: {
          query: { type: :string, example: 'trova tutti gli utenti attivi' },
          input: { type: :string, example: 'mostra i primi 10 ordini' }
        },
        required: ['query']
      }

      response '200', 'SQL generated successfully' do
        schema type: :object,
          properties: {
            sql: { type: :string, example: "SELECT * FROM users WHERE status = 'active'" },
            query: { type: :string, example: 'trova tutti gli utenti attivi' }
          },
          required: ['sql', 'query']

        let(:query) { { query: 'trova tutti gli utenti attivi' } }
        run_test!
      end

      response '400', 'Bad request' do
        schema type: :object,
          properties: {
            error: { type: :string, example: 'Query parameter is required' }
          }

        let(:query) { {} }
        run_test!
      end

      response '422', 'Unprocessable entity' do
        schema type: :object,
          properties: {
            error: { type: :string, example: 'Invalid query format' }
          }

        let(:query) { { query: 'invalid query' } }
        run_test!
      end
    end
  end
end
```

## Customization

You can override methods in your application to customize behavior:

### Overriding Parameter Handling

Override `set_magic_query_params` to customize how input parameters are read:

```ruby
# app/controllers/magic_query_controller.rb
class MagicQueryController < MagicQuery::Rails::MagicQueryController
  before_action :authenticate_user! # Add your authentication

  protected

  def set_magic_query_params
    @user_input = params[:custom_input] || params[:text]
  end
end
```

### Overriding Generator Configuration

Override `set_generator` to use a custom generator configuration:

```ruby
# app/controllers/magic_query_controller.rb
class MagicQueryController < MagicQuery::Rails::MagicQueryController
  before_action :authenticate_user!

  protected

  def set_generator
    # Custom generator configuration
    config = MagicQuery.configuration.dup
    config.api_key = current_user.openai_api_key
    @generator = MagicQuery::QueryGenerator.new(config)
  end
end
```

### Overriding Error Handling

Override `generate_sql_with_error_handling` to customize error handling behavior:

```ruby
# app/controllers/magic_query_controller.rb
class MagicQueryController < MagicQuery::Rails::MagicQueryController
  protected

  def generate_sql_with_error_handling
    sql = @generator.generate(@user_input)
    render json: { sql: sql, query: @user_input }
  rescue MagicQuery::Error => e
    # Custom error handling
    Rails.logger.error("MagicQuery error: #{e.message}")
    render json: { 
      error: e.message,
      error_code: e.class.name
    }, status: :unprocessable_entity
  rescue StandardError => e
    # Log unexpected errors
    Rails.logger.error("Unexpected error: #{e.message}")
    render json: { 
      error: "An error occurred while generating the query"
    }, status: :internal_server_error
  end
end
```

### Overriding the Generate Action

You can also override the entire `generate` action for complete control:

```ruby
# app/controllers/magic_query_controller.rb
class MagicQueryController < MagicQuery::Rails::MagicQueryController
  before_action :authenticate_user!
  before_action :check_rate_limit

  def generate
    if @user_input.blank?
      render json: { error: 'Query parameter is required' }, status: :bad_request
      return
    end

    # Your custom implementation
    result = @generator.generate(@user_input)
    render json: { 
      sql: result,
      query: @user_input,
      generated_at: Time.current.iso8601
    }
  end

  private

  def check_rate_limit
    # Your rate limiting logic
  end
end
```

## Available Methods

### Public Methods

#### `generate`

Main action that handles the HTTP request. Validates input and delegates to `generate_sql_with_error_handling`.

### Protected Methods

#### `set_magic_query_params`

Sets the user input from request parameters. By default, it reads from `params[:input]` or falls back to `params[:query]`.

**Override to:** Customize how input parameters are read from the request.

#### `set_generator`

Sets up the query generator instance. By default, uses `MagicQuery.configuration`.

**Override to:** Use a custom generator configuration (e.g., per-user API keys, different providers).

#### `generate_sql_with_error_handling`

Generates SQL from user input with error handling. Handles `MagicQuery::Error` and `StandardError` exceptions.

**Override to:** Customize error handling, logging, or response format.

## Example: Complete Custom Controller

```ruby
# app/controllers/magic_query_controller.rb
class MagicQueryController < MagicQuery::Rails::MagicQueryController
  before_action :authenticate_user!
  before_action :check_permissions
  before_action :log_request

  protected

  def set_magic_query_params
    @user_input = params[:query] || params[:input]
    @user_input = @user_input.strip if @user_input
  end

  def set_generator
    # Use user-specific API key
    config = MagicQuery.configuration.dup
    config.api_key = current_user.openai_api_key if current_user.openai_api_key.present?
    @generator = MagicQuery::QueryGenerator.new(config)
  end

  def generate_sql_with_error_handling
    sql = @generator.generate(@user_input)
    
    # Log successful generation
    Rails.logger.info("Generated SQL for user #{current_user.id}: #{sql}")
    
    render json: { 
      sql: sql, 
      query: @user_input,
      user_id: current_user.id
    }
  rescue MagicQuery::Error => e
    Rails.logger.warn("MagicQuery error for user #{current_user.id}: #{e.message}")
    render json: { error: e.message }, status: :unprocessable_entity
  rescue StandardError => e
    Rails.logger.error("Unexpected error for user #{current_user.id}: #{e.message}")
    Sentry.capture_exception(e) if defined?(Sentry)
    render json: { error: "An error occurred" }, status: :internal_server_error
  end

  private

  def check_permissions
    unless current_user.can_generate_queries?
      render json: { error: 'Permission denied' }, status: :forbidden
    end
  end

  def log_request
    Rails.logger.info("MagicQuery request from user #{current_user.id}: #{params[:query]}")
  end
end
```

## Routes

The controller is automatically mounted at `/magic_query/generate` when using the Rails engine. See [README.md](README.md#rails-integration) for setup instructions.

