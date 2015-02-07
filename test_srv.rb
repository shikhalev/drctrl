# encoding: utf-8

require 'drb'
require 'drctrl'

s = DRCtrl.start_service

DRb.thread.join
