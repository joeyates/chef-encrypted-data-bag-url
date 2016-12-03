# Chef::EncryptedDataBagUrl

Ease collaboration on your Chef kitchen's secrets by storing the data online,
for example in private Gists.

The principle use case for this gem is when you ue Chef Solo. In this case
there is no Chef Server instance where users can go and edit secrets via a web
interface. You have to check out the kitchen's repo, obtain a copy of the 
`secret_file` and edit the data bag with the 'knife-solo_data_bag' gem.

With this gem, you create a private Gist (or any other online secret file)
and write your secrets in JSON format, e.g.:

```json
{
  "foo_api_token": "fffuuuuuuuuuuuuuuu"
  "database": {
    "password": "secret"
  }
}
```

then put the URL of the **raw** Gist data in your encrypted data bag:

```json
{
  "id": "ciao",
  "data_url": "https://gist.githubusercontent.com/myuser/f95499c75cbe04f8cd7c42732729167d24928009/raw/7a05c4f72e41c1022d9b8d9067cc9aba601ea99e/secrets.json"
}
```

In your Chef cookbooks, instead of using
`Chef::EncryptedDataBagItem.load("foo", "bar").to_hash` to load your data,
use `Chef::EncryptedDataBagUrl`.

The result is a deep merge of the data in the data bag itself with the data
from the supplied URL.

Note that data bag contents are treated as defaults, and the data URL contents
override specific values.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chef-encrypted-data-bag-url'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chef-encrypted-data-bag-url

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will
allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`, which will create a git tag for
the version, push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/joeyates/chef-encrypted-data-bag-url.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
