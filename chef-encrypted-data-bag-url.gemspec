# coding: utf-8
lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "chef/encrypted_data_bag_url"

Gem::Specification.new do |spec|
  spec.name          = "chef-encrypted-data-bag-url"
  spec.version       = Chef::EncryptedDataBagUrl::VERSION
  spec.authors       = ["Joe Yates"]
  spec.email         = ["joe.g.yates@gmail.com"]

  spec.summary       = %q{Use online data with Chef data bags}
  spec.description   = <<-EOT
    Ease collaboration on your Chef kitchen's secrets by storing the data online,
    for example in private Gists.
  EOT

  spec.homepage      = "https://github.com/joeyates/chef-encrypted-data-bag-url"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
