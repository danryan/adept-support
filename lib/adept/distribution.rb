module Adept
  class Distribution

    attr_accessor :origin, :label, :codename, :arch, :description, :sign_with, :components

    def initialize(options={})
      @origin = options[:origin]
      @label = options[:label]
      @codename = options[:codename]
      @arch = options[:arch] || options[:architectures]
      @description = options[:description]
      @sign_with = options[:sign_with]
      @components = options[:components]
    end

    # Origin: apt.example.com
    # Label: apt repository
    # Codename: lucid
    # Architectures: i386 amd64 source
    # Components: main
    # Description: APT repository
    # SignWith: packages@example.com

    def to_file
      file = ""

      file << "Origin: #{origin}\n" if origin
      file << "Label: #{label}\n" if label
      file << "Codename: #{codename}\n" if codename
      file << "Architectures: #{arch.join(' ')}\n" if arch
      file << "Components: #{components.join(' ')}\n" if components
      file << "Description: #{description}\n" if description
      file << "SignWith: #{sign_with}\n" if sign_with
      file << "\n" unless file.empty?
      file.empty? ? nil : file
    end

  end
end
