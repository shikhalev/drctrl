# encoding: utf-8

require 'drb'

require_relative 'drctrl/version'

# Namespace module. Contains server-side methods if you use
#   require 'drctrl'
# and client-side methods if you use
#   require 'drctrl/client'
module DRCtrl

  # Controller service front object class.
  class Server

    # @yield Block without parameters which will be runned before stop
    #   the service.
    def initialize &block
      @block = block
    end

    # Stop the service.
    # @return [void]
    def stop
      if @block
        Thread.exclusive do
          block.call
        end
      end
      DRb.primary_server = DRCtrl.server
      DRb.stop_service
    end

    # Restart the service.
    # @return [Integer] Process ID for new process.
    def restart
      stop
      sleep 0
      spawn 'ruby', File.expand_path($0), *($*)
    end

  end

  class << self

    # @!group Server-side Module Attributes

    # DRCtrl server.
    # @return [DRb::DRbServer]

    attr_reader :server

    # @!endgroup

    # @!group Server-side Module Methods

    # Start control service with provided or default URI. Create
    # a {DRCtrl::Server} instance and start it as a front object of dRuby service.
    # @param uri [String] Optional. Custom URI for this control service.
    #    If not set the automated '+drbunix:+' socket will be used.
    # @param opts [Hash] Options for +DRb::start_service+.
    # @yield Block without parameters which will be runned before stop
    #   the service.
    # @return [DRb::DRbServer]

    def start_service uri: nil, **opts, &block
      if uri.nil?
        uri = "drbunix:/tmp/#{File.basename($0, '.rb')}-#{Process.pid}"
      end
      oldprim = DRb.primary_server
      @server = DRb.start_service uri, Server.new(&block), opts
      DRb.primary_server = oldprim if oldprim
      @server
    end

    # Wait when control service will be stopped.
    # @return [void]

    def wait
      @server.thread.join if @server
    end

    alias :join :wait

    # @!endgroup

  end

end
