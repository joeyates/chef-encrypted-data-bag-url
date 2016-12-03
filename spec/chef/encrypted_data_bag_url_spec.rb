require "spec_helper"

class FooError < StandardError; end

describe Chef::EncryptedDataBagUrl do
  let(:encrypted_data) { "encrypted_data" }
  let(:secret_key) { "secret_key" }
  let(:data_bag) { "data_bag" }
  let(:name) { "name" }
  let(:encrypted_data_bag_item) do
    instance_double(Chef::EncryptedDataBagItem, to_hash: data_bag_contents)
  end

  subject { described_class.load(data_bag, name) }

  before do
    allow(Chef::DataBagItem).to receive(:load).
                                with(data_bag, name) { encrypted_data }
    allow(Chef::EncryptedDataBagItem).to receive(:load_secret) { secret_key }
    allow(Chef::EncryptedDataBagItem).
      to receive(:new) { encrypted_data_bag_item }
  end

  context "when the data bag contains a `data_url`" do
    let(:data_bag_contents) do
      {"data_url" => data_url}
    end
    let(:data_url) { "http:/example.com" }

    context "when the online data is available" do
      before do
        allow(Net::HTTP).to receive(:get) { online_json }
      end

      context "when the online data is well-formed JSON" do
        let(:online_json) { online_data.to_json }
        let(:online_data) { {"ciao" => "hello"} }

        it "merges online data with data bag contents" do
          expect(subject.to_hash).to eq(data_bag_contents.merge(online_data))
        end

        context "when the data bag has common keys with the online data" do
          let(:data_bag_contents) do
            {
              "data_url" => data_url,
              "shared" => {"db" => 1, "common" => "db"},
              "data_bag_only" => "ok",
            }
          end
          let(:online_data) do
            {
              "shared" => {"on" => 1, "common" => "on"},
              "online_only" => "ok",
            }
          end
          let(:expected) do
            {
              "data_url" => data_url,
              "shared" => {"db" => 1, "on" => 1, "common" => "on"},
              "data_bag_only" => "ok",
              "online_only" => "ok",
            }
          end

          it "deep merges the data" do
            expect(subject.to_hash).to eq(expected)
          end
        end
      end

      context "when the online data is not well-formed JSON" do
        let(:online_json) { "Not JSON" }

        it "fails" do
          expect do
            subject.to_hash
          end.to raise_error(JSON::ParserError)
        end
      end
    end

    context "when the online data is unavailable" do
      before do
        allow(Net::HTTP).to receive(:get).and_raise(FooError.new)
      end

      it "fails" do
        expect do
          subject.to_hash
        end.to raise_error(FooError)
      end
    end
  end

  context "when the data bag doesn't contain a `data_url`" do
    let(:data_bag_contents) { {"data_bag_contents" => "foo"} }

    it "returns the data bag's contents" do
      expect(subject.to_hash).to eq(data_bag_contents)
    end
  end

  context "#encrypted_data" do
    it "is private" do
      expect do
        subject.encrypted_data
      end.to raise_error(NoMethodError, /private method .*?\bencrypted_data\b/)
    end
  end

  context "#secret_key" do
    it "is private" do
      expect do
        subject.secret_key
      end.to raise_error(NoMethodError, /private method .*?\bsecret_key\b/)
    end
  end

  it "has a version number" do
    expect(Chef::EncryptedDataBagUrl::VERSION).not_to be_nil
  end
end
