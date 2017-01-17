# mruby-cgroupv2   [![Build Status](https://travis-ci.org/haconiwa/mruby-cgroupv2.svg?branch=master)](https://travis-ci.org/haconiwa/mruby-cgroupv2)
CgroupV2 class
## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'haconiwa/mruby-cgroupv2'
end
```
## example
```ruby
p CgroupV2.hi
#=> "hi!!"
t = CgroupV2.new "hello"
p t.hello
#=> "hello"
p t.bye
#=> "hello bye"
```

## License
under the MIT License:
- see LICENSE file
