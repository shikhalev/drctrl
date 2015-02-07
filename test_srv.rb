# encoding: utf-8

require 'drb'
require 'drctrl'

DRCtrl.start_service

DRb.thread.join
