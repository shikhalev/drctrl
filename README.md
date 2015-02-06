# drctrl

A local control for DRb service.

[![Gem Version](https://badge.fury.io/rb/drctrl.svg)](http://badge.fury.io/rb/drctrl)
[![GitHub license](https://img.shields.io/badge/license-LGPLv3-orange.svg?style=flat)](https://raw.githubusercontent.com/shikhalev/drctrl/master/LICENSE)
[![Code Climate](https://codeclimate.com/github/shikhalev/drctrl/badges/gpa.svg)](https://codeclimate.com/github/shikhalev/drctrl)

This gem provides a local dRuby service for control purposes and a command line
tool for it.

## Usage

### At server side

```Ruby
require 'drctrl'

DRCtrl.start_service do
  # some finalize code
end
```

This code creates object with methods `stop` and `restart`. And it starts
a dRuby service at unix-socket `/tmp/<appname>-<pid>`.

### At client side

Use a command line tool `drctrl` or your own code with
`require 'drctrl/client'`.

`drctrl` find appropriate dRuby server and send to it command and arguments.

```
drctrl [<options>] <command> [<args>]
    -U, --uri=URI
    -P, --path=PATH
    -N, --name=NAME
    -I, --pid=PID
```

There is required to set one of options: `--uri` (any dRuby URI), `--path`
(a path to unix-socket), or `--name` (name of controlled app).
