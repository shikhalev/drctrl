# encoding: utf-8

require 'drb'

require_relative 'version'

module DRCtrl

  class << self

    def detect name, pid = nil
      if pid
        result = "/tmp/#{name}-#{pid}"
        if File.socket? result
          return result
        else
          return nil
        end
      else
        files = Dir["/tmp/#{name}*"]
        result = files.select { |f| File.socket? f }
        if result.length == 0
          return nil
        elsif result.length == 1
          return result[0]
        else
          return result
        end
      end
    end

    def connect uri: nil, path: nil, name: nil, pid: nil
      if uri
        DRbObject.new nil, uri
      elsif path
        DRbObject.new nil, "drbunix:#{path}"
      elsif name
        socket = detect name, pid
        case socket
        when String
          DRbObject.new nil, "drbunix:#{socket}"
        when Array
          socket.map { |s| DRbObject.new nil, "drbunix:#{s}" }
        else
          raise RuntimeError, "Socket for { name: #{name.inspect}," +
              " pid: #{pid.inspect} } not found!", caller
        end
      else
        raise ArgumentError,
            "One of this arguments: uri, path or name must be setted!", caller
      end
    end

  end

end

$stderr.puts [Gem::Specification::.find { |spec|
              File.fnmatch(File.join(spec.full_gem_path,'*'), __FILE__)
             }, __FILE__].inspect
