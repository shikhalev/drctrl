# drctrl

A local control for DRb service.

This gem provides a local dRuby service for control purposes and a command line
tool for it.

## Usage

### At server-side

```Ruby
require 'drctrl'

DRCtrl.start_service do
  # some finalize code
end
```


