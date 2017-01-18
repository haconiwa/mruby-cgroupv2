MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'

  conf.gem mgem: "mruby-process"
  conf.gem github: "haconiwa/mruby-exec"

  conf.gem '../mruby-cgroupv2'
  conf.enable_test
  conf.enable_debug
end
