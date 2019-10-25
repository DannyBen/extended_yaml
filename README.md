Extended YAML
==================================================

[![Gem Version](https://badge.fury.io/rb/extended_yaml.svg)](https://badge.fury.io/rb/extended_yaml)
[![Build Status](https://travis-ci.com/DannyBen/extended_yaml.svg?branch=master)](https://travis-ci.com/DannyBen/extended_yaml)
[![Maintainability](https://api.codeclimate.com/v1/badges/0d162ff84c50abe7c83a/maintainability)](https://codeclimate.com/github/DannyBen/extended_yaml/maintainability)

---

ExtendedYAML adds a couple of additional features to the standard YAML 
library:

1. Each YAML file can extend (inherit from) other YAML files by specifying
   `extends: other_file` 
2. YAML files are parsed for ERB tags.

It is a simpler reimplementation of [yaml_extend][1].


Installation
--------------------------------------------------


    $ gem install extended_yaml



Usage
--------------------------------------------------

Given this [simple.yml](examples/simple.yml) file:

```yaml
extends: subdir/production.yml

settings:
  host: localhost
  port: 80
```

which uses `extends` to load this
[subdir/production.yml](examples/subdir/production.yml) file.

```yaml
settings:
  host: example.com
```

We can now load the extended YAML file likw this:

```ruby
# Load an extended YAML
require 'extended_yaml'

p ExtendedYAML.load 'examples/simple.yml'
#=> {"settings"=>{"host"=>"example.com", "port"=>80}}
```

Notes
--------------------------------------------------

1. Arrays will be merged.
2. Nested hashes will be merged.
3. Other types of values will be overridden based on which loaded file was
   the last to define them.
4. ERB tags will be evaluated in all YAML files.
5. The `extends` option can use either a single file string, or an array. 
   Extensions are optional.
6. If you need to use a key that is named differently, provide it using the
   `key` keyword argument:
   ```ruby
   ExtendedYAML.load 'examples/simple.yml', key: 'include'
   ```

See the [examples/master.yml](examples/master.yml) file for additional
information.


[1]: https://github.com/magynhard/yaml_extend