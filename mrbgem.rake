MRuby::Gem::Specification.new('mruby-cgroupv2') do |spec|
  spec.license = 'MIT'
  spec.authors = 'Uchio Kondo'

  spec.add_dependency "mruby-string-ext", core: "mruby-string-ext"
  spec.add_dependency "mruby-io"
  spec.add_dependency "mruby-dir"
  spec.add_dependency "mruby-process"

end
