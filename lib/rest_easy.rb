require "rest-client"
require "rest_easy/version"

module RestEasy
  extend self

  #
  # Wait until an API call block resolves to true or the timeout
  # is reached. The default is 10 seconds.
  #
  # @param uri     [String] API endpoint
  # @param timeout [Fixnum] time to wait until false is returned
  # @param opts    [Hash]   options yielded to block
  # @param block   [Proc]   API call to evaluate
  #
  # @return [Boolean]
  #
  def get_until uri, timeout = 10, opts = {}, &block
    iterate timeout do
      result = RestClient.get(uri, opts){ |resp| yield resp }
      return true if result
      sleep 0.5
    end
  end

  #
  # Wait while an API call block resolves to true or the timeout
  # is reached. The default is 10 seconds.
  #
  # @param uri     [String] API endpoint
  # @param timeout [Fixnum] time to wait until false is returned
  # @param opts    [Hash]   options yielded to block
  # @param block   [Proc]   API call to evaluate
  #
  # @return [Boolean]
  #
  def get_while uri, timeout = 10, opts = {}, &block
    iterate timeout do
      result = RestClient.get(uri, opts){ |resp| yield resp }
      return true unless result
      sleep 0.5
    end
  end

  private
  
  def iterate timeout, &block
    timed_out = Time.now + timeout
    yield block until Time.now > timed_out
    false
  end
end
