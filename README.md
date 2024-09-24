# Todo API
This is a Rails API project that includes user authentication with Devise and JWT, GraphQL support, AWS S3 integration, and authorization with Pundit.

## Frontend

The frontend of this project can be found at [todo_pro](https://github.com/rubemoon/todo_pro).

## Prerequisites

- Ruby 3.3.4
- Rails 7.2.1
- PostgreSQL

## Getting Started

### Install dependencies:

```sh
bundle install
```

### Set up the database:

```sh
rails db:create db:migrate
```

### Create a .env file in the root directory and add your environment variables:

```sh
cp .env.example .env
```

Then, edit the `.env` file to include your actual values.

## Running the Server

Start the Rails server:

```sh
rails server
```

## GraphQL

### To access the GraphiQL interface (in development mode):

Navigate to `http://localhost:3000/graphiql`.

### To execute GraphQL queries:

Send POST requests to `http://localhost:3000/graphql`.

## Health Check

### To check if the server is running:

Navigate to `http://localhost:3000/health_check`.

## Authentication

This project uses Devise and JWT for authentication. To sign up or log in, use the following GraphQL mutations:

### Sign Up

```graphql
mutation {
    signUpUser(email: "user@example.com", password: "password", passwordConfirmation: "password") {
        user {
            id
            email
        }
        token
        errors
    }
}
```

### Sign In

```graphql
mutation {
    signInUser(email: "user@example.com", password: "password") {
        token
        errors
        user {
            id
            email
        }
    }
}
```

### Create Todo

```graphql
mutation {
    createTodo(title: "New Todo", description: "Todo description", dueDate: "2023-12-31T23:59:59Z", completed: false) {
        todo {
            id
            title
            description
            dueDate
            completed
        }
        errors
    }
}
```

## Authorization

This project uses Pundit for authorization. Below is an example of a `TodoPolicy`:

```ruby
class TodoPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user) # Only return todos that belong to the current user
    end
  end

  def create?
    user.present? # Only logged-in users can create todos
  end

  def update?
    user.present? && record.user == user # Only the owner can update their todos
  end

  def destroy?
    user.present? && record.user == user # Only the owner can delete their todos
  end
end
```

## Environment Variables

The project uses dotenv-rails to manage environment variables. Here is an example of the `.env` file:

```env
SECRET_KEY_BASE=your_secret_key_base
DEVISE_JWT_SECRET_KEY=your_devise_jwt_secret_key
AWS_REGION=your_aws_region
AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
AWS_BUCKET=your_aws_bucket_name
RAILS_MASTER_KEY=your_rails_master_key
```

## CORS Configuration

Be sure to restart your server when you modify this file.

Avoid CORS issues when API is called from the frontend app. Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

Read more: [https://github.com/cyu/rack-cors](https://github.com/cyu/rack-cors)

### `config/initializers/cors.rb`

```ruby
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Allow requests from any origin in development
    if Rails.env.development?
      origins "*"
    else
      # Restrict origins in production
      origins "https://your-production-frontend.com"
    end

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      credentials: true
  end
end
```

## Contributing

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature-branch`)
5. Create a new Pull Request

## License

This project is licensed under the MIT License.
