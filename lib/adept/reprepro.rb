require 'pathname'

module Adept
  class Reprepro

    ROOT_DIR = "/tmp/"

    attr_accessor :repo

    def initialize(options={})
      @base = options[:base] || "/tmp"
      @repo = Pathname.new(File.join(@base, options[:name]))
    end

    def exist?
      ::File.exist?(repo)
    end

    def init(options={})
      FileUtils.mkdir_p(repo)
      %w[ conf db dists pool tarballs ].each do |dir|
        FileUtils.mkdir_p(repo + dir)
      end
      File.open(repo + "conf" + "distributions", "w+") do |f|
        options[:distributions].each do |dist|
          f.write Distribution.new(dist).to_file
        end
      end
    end

  end
end
