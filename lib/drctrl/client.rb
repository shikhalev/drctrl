# encoding: utf-8

require 'drb'

require_relative 'version'

module DRCtrl

  class << self

    # @!group Client-side Module Methods

    # Find socket path for name and process ID.
    # @param [String] name Application name.
    # @param [Integer] pid Process ID.
    # @return [String, Array<String>, nil]

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

    # Connect to dRuby socket(-s).
    # @param uri [String] Socket's URI.
    # @param path [String] Path to unix-socket.
    # @param name [String] Application name.
    # @param pid [Integer] Process ID.
    # @return [DRb::DRbObject, Array<DRbObject>, nil]
    # @raise [RuntimeError] If socket not found.
    # @raise [ArgumentError] If no required arguments setted.

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

    # @!endgroup

  end

end


