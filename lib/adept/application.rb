require 'sinatra/base'
require 'sinatra/reloader'
require 'rack/utils'
require 'rack/mime'

module Adept
  class Application < Sinatra::Base
    configure :development do
      register Sinatra::Reloader
    end

    get %r{/apt([/\w]+)} do |path|
      list_directory
    end

    def stat(node)
      stat = File.stat(node)
    rescue Errno::ENOENT, Errno::ELOOP
      nil
    end

    def root
      @root ||= "/tmp"
    end

    def list_directory
      @files = []
      @script_name = env['SCRIPT_NAME']
      @path_info = env['PATH_INFO']

      @path = File.join(root, @path_info)

      @glob = File.join(@path, '*')
      puts @glob

      url_head = (@script_name.split('/') + @path_info.split('/')).map do |part|
        Rack::Utils.escape(part)
      end

      Dir[@glob].sort.each do |node|
        begin
          stat = File.stat(node)
        rescue Errno::ENOENT, Errno::ELOOP
          stat = nil
        end

        next unless stat
        basename = File.basename(node)
        ext = File.extname(node)

        url = File.join(*url_head + [Rack::Utils.escape(basename)])
        size = stat.size
        type = stat.directory? ? 'directory' : Rack::Mime.mime_type(ext)
        mtime = stat.mtime.httpdate
        url << '/' if stat.directory?
        basename << '/' if stat.directory?

        @files << [ url, basename, size, type, mtime ]
      end

      @stat = File.stat(@path)

      if @stat.readable?
        return @path if @stat.file?
        return list_directory if @stat.directory?
      else
        raise Errno::ENOENT, 'No such file or directory'
      end
    end
  end
end