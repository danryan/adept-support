require 'mixlib/shellout'

module Adept
  module Support
    class Repo

      attr_accessor :name, :path, :distributions

      def initialize(options={})
        @name = options[:name]
      end

      def self.init(options={})
        reprepro = Reprepro.new(options)

        unless reprepro.exist?
          reprepro.init(options)
        end

        self.new(options)
      end

      def add(distribution, file)
        run("includedeb", distribution, file)
      end

      def remove(distribution, package)
        run("remove", distribution, package)
      end

      def list(codename)
        run("list", codename)
      end

      private

      def run(*command_args)
        command_args.unshift("reprepro", "-V", "-b #{path}")
        cmd = Mixlib::ShellOut.new(*command_args)
        cmd.run_command
      end

    end
  end
end
