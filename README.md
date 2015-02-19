# RestEasy

This gem is a little testing tool I created to help with synchronization issues in a test suite. I was validating automated UI actions against a low-resource test environment API, and those validations were failing in the first second or two following an action. The `rest_easy` gem wraps my API calls in a timeout functionality, letting me iterate until the validation passes or times out after a number of seconds.

## Example

I took a test that once looked like this (because of a slow test environment):

```ruby
it "saves my edit" do
  page_object.field = "Something"
  page_object.save
  sleep 5
  expect(JSON.load(RestClient.get "/call/to/my/API")['data']['field']).to eq('Something')
end
```

And turned it into this:

```ruby
it "saves my edit" do
  page_object.field = "Something"
  page_object.save
  expect(get_until("/call/to/my/API", 5){|data| JSON.load(data)['data']['field'] == 'Something'}).to be true
end
```

My hard-coded sleep of 5 seconds was wasteful. Now, the test only waits as long as it absolutely needs. It might be 1 second today or 4.5 seconds tomorrow. If it's longer than 5 seconds, the test will fail.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rest_easy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rest_easy

## Usage

```ruby
# fails after 10 seconds
RestEasy.get_until('http://twitter.com'){ 1 == 0 }

# fails after 3 seconds
RestEasy.get_while('http://twitter.com', 3){ 1 == 1 }

# pass the GET response to your validation block
RestEasy.get_until('http://twitter.com'){ |response| response.code == 200 }

# add cookies to your GET request with the options hash
RestEasy.get_while('http://twitter.com', 10, cookies: {auth_token: 'blah'}){ |response| response.code == 403 }
```

## Todo
The gem is tied to `rest-client`, but I'd like to make any REST gem work. Also, I've only written methods for GETs. I need to add POSTs, PUTs, etc. Pull requests are welcome!

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rest_easy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
