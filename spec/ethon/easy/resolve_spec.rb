require 'spec_helper'

describe Ethon::Easy::Resolve do
  let(:easy) { Ethon::Easy.new }

  describe "#resolvers=" do
    let(:resolvers) { { 'www.example.com:3001' => '127.0.0.1' } }

    it "sets resolvers" do
      expect_any_instance_of(Ethon::Easy).to receive(:set_callbacks)
      expect(Ethon::Curl).to receive(:set_option)
      easy.resolve_overrides = resolvers
    end

    context "when requesting" do
      before do
        easy.resolve_overrides = resolvers
        easy.url = "http://www.example.com:3001/fail_forever"
        easy.perform
      end

      it "sends" do
        expect(easy.response_code).to eq(500)
      end
    end
  end

  describe "#resolver_list" do
    context "when no resolve_overrides" do
      it "returns nil" do
        expect(easy.resolver_list).to eq(nil)
      end
    end

    context "when resolve_overrides" do
      it "returns pointer to resolver list" do
        easy.resolve_overrides = {'www.example.com:80' => '127.0.0.1'}
        expect(easy.resolver_list).to be_a(FFI::Pointer)
      end
    end
  end
end
