# RestEasy

The `rest_easy` gem allows you to call an API until its response passes validation (a block) or times out. It's inspired by the `wait_until` functionality common to webdrivers, and I've found it useful in my acceptance testing.

## Example

I've had tests that may have looked like this:

```ruby
it "saves my edit" do
  page_object.field = "Something"
  page_object.save
  sleep 5
  expect(JSON.load(RestClient.get "/call/to/my/API")['data']['field']).to eq('Something')
end
```

We waited 5 seconds because it could take 1-5 seconds for us to see our edit reflected in the API response (for whatever reason). That's kind of annyoing, especially if it would have only taken 1 second to see the correct response. So, with rest_reasy, the test can look like this:

```ruby
it "saves my edit" do
  page_object.field = "Something"
  page_object.save
  expect(RestEasy.get_until("/call/to/my/API", 5){|data| JSON.load(data)['data']['field'] == 'Something'}).to be_truthy
end
```

Our test now only waits until it gets the response it needs. If that takes 1 second, then our test is 4 seconds faster! If we've broken some functionality, the test will fail after 5 seconds.

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

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rest_easy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
