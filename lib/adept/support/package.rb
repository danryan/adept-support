require 'pathname'

module Adept
  module Support
    class Package
      VALID_FIELDS = %w[
      package source version section priority architecture essential 
      depends recommends suggests enhances pre_depends breaks conflicts provides replaces 
      build_depends build_conflicts build_depends_indep build_conflicts_indep built_using
    ]

      class_eval do
        VALID_FIELDS.each do |field|
          define_method field do
            if instance_variable_defined?("@#{field}")
              instance_variable_get("@#{field}")
            else
              instance_variable_set("@#{field}", read_field(field))
              instance_variable_get("@#{field}")
            end
          end
        end
      end

      attr_accessor :file, :component, :distro

      def initialize(attrs={})
        @file = attrs[:file]
        @distro = attrs[:distro]
        @component = attrs[:component]
      end

      def parse_filename
        # ^([a-zA-Z0-9-+]+)_([\d\.]+)-(.+)?[_~]?_([a-zA-Z0-9-]+)\.deb$
      end

      def to_path
        path = Pathname.new('pool')
        path += component

        name = source || package
        if name =~ /^lib/
          path += name[0..3]
        else
          path += name[0]
        end
        path += name
        path += file
        path.to_s
      end

      def control
        run("-f #{file}")
      end

      def contents
        run("-c #{file}")
      end

      # private

      def read_field(field)
        # raise Errno::NOENT, "No such file or directory - #{file}" unless ::File.exist?(file)
        output = run("-f #{file} #{field.to_s.to_dpkg_field}").chomp
        if output.empty?
          nil
        else
          output
        end
      end

      def dpkg(*command_args)
        command_args.unshift("dpkg-deb")
        cmd = Mixlib::ShellOut.new(*command_args)
        cmd.run_command
      end
    end
  end

end
