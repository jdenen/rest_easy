require 'rspec'
require 'rest_easy'

describe RestEasy do
  let(:uri){ "http://example.com" }
  
  describe "#get_until" do
    it "performs an HTTP GET through the REST client" do
      expect(RestClient).to receive(:get).with(uri, Hash).and_return(true)
      RestEasy.get_until(uri){ |resp| resp }
    end
    
    context "when given block resolves to true" do
      it "returns true" do
        expect(RestClient).to receive(:get).and_return(true)
        expect(RestEasy.get_until(uri){ |resp| resp }).to be true
      end
    end

    context "when given block never resolves to true" do
      before do
        expect(RestClient).to receive(:get).twice.and_return(false)
      end
      
      it "returns false" do
        expect(RestEasy.get_until(uri, 1){ |resp| resp }).to be false
      end

      it "waits to timeout" do
        start = Time.now
        RestEasy.get_until(uri, 1){ |resp| resp }
        duration = Time.now - start
        expect(duration).to be_between 1, 2
      end
    end
  end

  describe "#get_while" do
    it "performs an HTTP GET through the REST client" do
      expect(RestClient).to receive(:get).with(uri, Hash).and_return(false)
      RestEasy.get_while(uri){ |resp| resp }
    end
    
    context "when given block continues to resolve to true" do
      before do
        expect(RestClient).to receive(:get).twice.and_return(true)
      end
      
      it "returns false" do
        expect(RestEasy.get_while(uri, 1){ |resp| resp }).to be false
      end

      it "waits to timeout" do
        start = Time.now
        RestEasy.get_while(uri, 1){ |resp| resp }
        duration = Time.now - start
        expect(duration).to be_between 1, 2
      end
    end

    context "when given block resolves to false" do
      it "returns true" do
        expect(RestClient).to receive(:get).and_return(false)
        expect(RestEasy.get_while(uri){ |resp| resp }).to be true
      end
    end
  end
end
