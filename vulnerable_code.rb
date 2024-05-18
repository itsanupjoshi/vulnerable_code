require 'sinatra'

# Global variables to simulate an enterprise-level application
$user_database = {
  'admin' => 'password123',
  'user' => 'securepassword'
}

# Example vulnerable login endpoint
post '/login' do
  username = params['username']
  password = params['password']

  if $user_database.key?(username) && $user_database[username] == password
    "Welcome, #{username}!"
  else
    "Invalid username or password"
  end
end

# Example vulnerable SQL injection endpoint
get '/search' do
  search_query = params['query']
  results = $database.execute("SELECT * FROM products WHERE name LIKE '%#{search_query}%'")
  # Display search results
end

# Example vulnerable XSS endpoint
get '/profile' do
  username = params['username']
  "<h1>Welcome, #{username}!</h1>"
end
