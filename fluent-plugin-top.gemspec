# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-top"
  spec.version       = "0.1.1"
  spec.authors       = ["Tetsu Izawa (@moccos)"]
  spec.email         = ["tt.izawa@gmail.com"]
  spec.homepage      = "https://github.com/moccos/fluent-plugin-top"

  spec.summary       = %q{Fluentd top command input plugin}
  spec.description   = %q{Fluentd top command input plugin}
  spec.licenses      = ["Apache License, Version 2.0"]

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>=2.0'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "fluentd", ">= 0.12.0"
  spec.add_runtime_dependency "fluent-mixin-rewrite-tag-name"
end
