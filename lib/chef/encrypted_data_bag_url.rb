require "chef/encrypted_data_bag_item"
require "json"
require "net/http"

class Chef::EncryptedDataBagUrl
  VERSION = "0.1.0"

  def self.load(data_bag, name, secret = nil)
    encrypted_data = Chef::DataBagItem.load(data_bag, name)
    secret_key = secret || Chef::EncryptedDataBagItem.load_secret
    new(encrypted_data, secret_key)
  end

  def initialize(encrypted_data, secret_key)
    @encrypted_data = encrypted_data
    @secret_key = secret_key
    @encrypted_data_bag_item = nil
    @online_data = nil
  end

  def to_hash
    deep_merge(data_bag_hash, online_data)
  end

  private

  attr_reader :encrypted_data
  attr_reader :secret_key

  def encrypted_data_bag_item
    @encrypted_data_bag_item ||= Chef::EncryptedDataBagItem.new(
      encrypted_data, secret_key
    )
  end

  def data_bag_hash
    encrypted_data_bag_item.to_hash
  end

  def data_url
    data_bag_hash["data_url"]
  end

  def online_data
    return @online_data if @online_data

    if !data_url
      @online_data = {}
      return @online_data
    end

    online_json = Net::HTTP.get(URI.parse(data_url))
    @online_data = JSON.parse(online_json)
  end

  # Adapted from
  # http://stackoverflow.com/questions/9381553/ruby-merge-nested-hash/30225093#30225093
  def deep_merge(first, second)
    merger = ->(key, v1, v2) do
      if Hash === v1 && Hash === v2
        v1.merge(v2, &merger)
      else
        if Array === v1 && Array === v2
          v1 | v2
        else
          if [:undefined, nil, :nil].include?(v2)
            v1
          else
            v2
          end
        end
      end
    end

    first.merge(second.to_h, &merger)
  end
end
