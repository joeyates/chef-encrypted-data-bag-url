# Chef::EncryptedDataBagUrl

Ease collaboration on your Chef kitchen's secrets by storing the data online,
for example in private Gists.

# Idea

The principal use case for this gem is when you use Chef Solo. In this case
there is no Chef Server instance where users can go and edit secrets via a web
interface. If you want to edit secrets, you have to check out the kitchen's
repo, obtain a copy of the `secret_file` and edit the data bag.

chef-encrypted-data-bag-url allows you to create a secret file (for example a
Gist or a GitLab snippet) and use that file as your source of secrets.

You can edit your secret using your web browser and then re-run chef deploy.

# Usage

## Online

With this gem, you create a private Gist (or any other online secret file)
and write your secrets in JSON format, e.g.:

```json
{
  "foo_api_token": "new_value",
  "database": {
    "password": "secret"
  }
}
```

## Data Bag

then put the URL of the **raw** Gist data in your encrypted data bag:

```json
{
  "id": "ciao",
  "data_url": "https://gist.githubusercontent.com/myuser/f95499c75cbe04f8cd7c42732729167d24928009/secrets.json",
  "foo_api_token": "old_value"
}
```

## Cookbook

```
chef_gem "chef-encrypted-data-bag-url" do
  compile_time true
end

require "chef/encrypted_data_bag_url"

node.default["foo"]["bar"] = Chef::EncryptedDataBagUrl.load("secrets", "fred").to_hash
```

In your Chef cookbooks, instead of using
`Chef::EncryptedDataBagItem.load("foo", "bar").to_hash` to load your data,
you use `Chef::EncryptedDataBagUrl.load("foo", "bar").to_hash`.

The result is a **deep** merge of the data in the data bag itself with the data
from the supplied URL:

```json
{
  "id": "ciao",
  "data_url": "https://gist.githubusercontent.com/myuser/f95499c75cbe04f8cd7c42732729167d24928009/secrets.json",
  "foo_api_token": "new_value",
  "database": {
    "password": "secret"
  }
}
```

Note that data bag contents are treated as defaults, and the data URL contents
override matching values (as in the example of `foo_api_token` above).

## Notes

### Chef `why-run`

Unfortunately, until you actually install the gem, chef `why-run` will fail
with:

```
LoadError
---------
cannot load such file -- chef/encrypted_data_bag_url
```

### Gist URLs

Gist raw URLS are versioned. Every time you change the contents of the Gist,
and click on the 'Raw' link you get a URL like this:

```
https://gist.githubusercontent.com/myuser/aaaaaaaaaaaaaaa/raw/bbbbbbb/gistfile1.txt
```

You can get a permalink to the **latest** version like this:

```
https://gist.githubusercontent.com/myuser/aaaaaaaaaaaaaaa/raw/gistfile1.txt
```

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
