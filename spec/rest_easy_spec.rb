require 'rspec'
require 'rest_easy'

describe RestEasy do
  describe ".get_until" do
    context "with passing validation" do
      it "passes uri and options to RestClient" do
        expect(RestClient).to receive(:get).with('url', header: 'header').once.and_return(true)
        RestEasy.get_until('url', 1, header: 'header'){ |r| r }
      end
      
      it "returns true after one iteration" do
        expect(RestClient).to receive(:get).once.and_return(true)
        expect(RestEasy.get_until('url'){ |r| r }).to be_truthy
      end
    end

    context "with failing validation" do
      it "returns false" do
        expect(RestClient).to receive(:get).twice.and_return(false)
        expect(RestEasy.get_until('url', 1){ |r| r }).to be_falsey
      end
      
      it "times out after 10 seconds default" do
        start_time = Time.now
        expect(RestClient).to receive(:get).exactly(20).times.and_return(false)
        RestEasy.get_until('url'){ |r| r }
        expect(Time.now - start_time).to be > 10
      end
      
      it "times out after n seconds" do
        start_time = Time.now
        expect(RestClient).to receive(:get).exactly(6).times.and_return(false)
        RestEasy.get_until('url', 3){ |r| r }
        expect(Time.now - start_time).to be_within(1).of(3).and be > 3
      end
    end
  end

  describe ".get_while" do
    context "with passing validation" do
      it "passes uri and options to RestClient" do
        expect(RestClient).to receive(:get).with('url', header: 'header').once.and_return(false)
        RestEasy.get_while('url', 1, header: 'header'){ |r| r }
      end
      
      it "returns true after one iteration" do
        expect(RestClient).to receive(:get).once.and_return(false)
        expect(RestEasy.get_while('url'){ |r| r }).to be_truthy
      end
    end

    context "with failing validation" do
      it "returns false" do
        expect(RestClient).to receive(:get).twice.and_return(true)
        expect(RestEasy.get_while('url', 1){ |r| r }).to be_falsey
      end

      it "times out after 10 seconds by default" do
        start_time = Time.now
        expect(RestClient).to receive(:get).exactly(20).times.and_return(true)
        RestEasy.get_while('url'){ |r| r }
        expect(Time.now - start_time).to be > 10
      end

      it "times out after n seconds" do
        start_time = Time.now
        expect(RestClient).to receive(:get).exactly(6).times.and_return(true)
        RestEasy.get_while('url', 3){ |r| r }
        expect(Time.now - start_time).to be_within(1).of(3).and be > 3
      end
    end
  end
end
