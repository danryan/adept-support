require 'pathname'

module Adept
  module Support
    class Package
      VCS_FIELDS = [
        :vcs_browser,
        :vcs_arch,
        :vcs_git,
        :vcs_bzr,
        :vcs_cvs,
        :vcs_darcs,
        :vcs_hg,
        :vcs_mtn,
        :vcs_svn
      ]

      DEPENDS_FIELDS = [
        :depends,
        :pre_depends,
        :recommends,
        :suggests,
        :enhances,
        :breaks,
        :conflicts
      ]

      BUILD_FIELDS = [
        :build_depends,
        :build_depends_indep,
        :build_conflicts,
        :build_conflicts_indep,
      ]

      CHECKSUMS_FIELDS = [
        :checksums_sha1,
        :checksums_sha256
      ]

      SOURCE_PACKAGE_GENERAL_FIELDS = [
        :source,
        :maintainer,
        :uploaders,
        :section,
        :priority,
        :standards_version,
        :homepage,
        *VCS_FIELDS,
        *BUILD_FIELDS
      ]

      SOURCE_PACKAGE_BINARY_FIELDS = [
        :package,
        :architecture,
        :section,
        :priority,
        :essential,
        *DEPENDS_FIELDS,
        :description,
        :homepage,
        :built_using
      ]

      CONTROL_FIELDS = [
        :package,
        :source,
        :version,
        :section,
        :priority,
        :architecture,
        :essential,
        *DEPENDS_FIELDS,
        :installed_size,
        :maintainer,
        :description,
        :homepage,
        :built_using,
        :license
      ]

      SOURCE_CONTROL_FIELDS = [
        :format,
        :source,
        :binary,
        :architecture,
        :version,
        :maintainer,
        :uploaders,
        :homepage,
        *VCS_FIELDS,
        :standards_version,
        *BUILD_FIELDS,
        *CHECKSUMS_FIELDS,
        :files
      ]

      CHANGES_FIELDS = [
        :format,
        :date,
        :source,
        :binary,
        :architecture,
        :version,
        :distribution,
        :urgency,
        :maintainer,
        :changed_by,
        :description,
        :closes,
        :changes,
        *CHECKSUMS_FIELDS,
        :files
      ]

      VALID_FIELDS = [
        *VCS_FIELDS,
        *DEPENDS_FIELDS,
        *BUILD_FIELDS,
        *CHECKSUMS_FIELDS,
        *SOURCE_PACKAGE_GENERAL_FIELDS,
        *SOURCE_PACKAGE_BINARY_FIELDS,
        *CONTROL_FIELDS,
        *SOURCE_CONTROL_FIELDS,
        *CHANGES_FIELDS
      ].flatten.compact.uniq

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
