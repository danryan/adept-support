$: << File.dirname(__FILE__) + '/../lib' unless $:.include?(File.dirname(__FILE__) + '/../lib/')

require 'rubygems'
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

repo.add("lucid", "postgresql-client-9.0_9.0.5-1~lucid_amd64.deb")
repo.list("lucid")
# => lucid|main|amd64: postgresql-client-9.0 9.0.5-1~lucid