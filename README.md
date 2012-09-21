# Adept

**a·dept**   [***adj***. *uh*-**dept**; ***n***. **ad**-ept, *uh*-**dept**]

1. very skilled; proficient; expert: *an adept juggler.*
2. synonym for **apt**: *a package manager.*

For now, adept is a thin wrapper around reprepro. More to come later.

## Installation

Add this line to your application's Gemfile:

    gem 'adept'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adept

## Usage

```ruby
require 'adept'

options = {
  :name => "bar",
  :distributions => [
    {
      :origin => "apt.example.com",
      :label => "apt repository for bar",
      :codename => "lucid",
      :arch => %w[ i386 amd64 ],
      :components => %w[ main ],
      :description => "APT repository for internal packages",
      :sign_with => "packages@example.com"
    }
  ]
}

repo = Adept::Repo.init(options)
repo.add("lucid", "/path/to/postgresql-client-9.0_9.0.5-1~lucid_amd64.deb")
repo.list("lucid")
# => lucid|main|amd64: postgresql-client-9.0 9.0.5-1~lucid
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
