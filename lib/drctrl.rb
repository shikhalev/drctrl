# encoding: utf-8

require 'drb'

require_relative 'drctrl/version'

module DRCtrl

  class Server

    def initialize &block
      @block = block
    end

    def stop
      DRb.stop_service
      sleep 0
      if @block
        block.call
      end
    end

    def restart
      stop
      sleep 0
      Process.exec File.expand_path($0)
    end

  end

  class << self

    def start_service uri: nil, **opts, &block
      if uri.nil?
        uri = "drbunix:/tmp/#{File.basename($0)}-#{Process.pid}"
      end
      DRb.start_service uri, Server.new(&block), opts
    end

  end

end
