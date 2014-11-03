require "rest-client"
require "rest_easy/version"

module RestEasy
  extend self
  
  def get_until uri, timeout = 10, opts = {}, &block
    iterate timeout do
      result = RestClient.get(uri, opts){ |resp| yield resp }
      return result if result
      sleep 0.5
    end
  end

  def get_while uri, timeout = 10, opts = {}, &block
    iterate timeout do
      result = RestClient.get(uri, opts){ |resp| yield resp }
      return !result unless result
      sleep 0.5
    end
  end

  def iterate timeout, &block
    end_time = Time.now + timeout
    yield block until Time.now > end_time
    false
  end
end
