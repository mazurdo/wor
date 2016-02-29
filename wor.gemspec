# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Maintain your gem's version:
require "wor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "wor"
  s.version     = Wor::VERSION

  s.licenses      = ["MIT"]
  s.authors  = ["Javi Sanromán"]
  s.email    = ["javisanroman@gmail.com"]

  s.homepage    = "https://github.com/jsanroman/wor"
  s.summary     = ""
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.22"
  s.add_dependency "rspec"
  s.add_dependency "rails-settings-cached"
  s.add_dependency "jbuilder"
  s.add_dependency "will_paginate", "3.0.5"
  s.add_dependency "shortcode"
  s.add_dependency "el_finder", "1.1.12"
  s.add_dependency "pundit"
  s.add_dependency "paper_trail"
  s.add_dependency "disqus_api"
  s.add_dependency "tinymce-rails"
  s.add_dependency "rmagick"

  s.add_development_dependency "sqlite3"
end
