# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{xbel}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian A\303\237mann"]
  s.date = %q{2009-11-12}
  s.description = %q{}
  s.email = %q{florian.assmann@email.de}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     ".watchr",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "lib/nokogiri/decorators/xbel.rb",
     "lib/nokogiri/decorators/xbel/alias.rb",
     "lib/nokogiri/decorators/xbel/bookmark.rb",
     "lib/nokogiri/decorators/xbel/folder.rb",
     "lib/nokogiri/decorators/xbel/separator.rb",
     "lib/xbel.rb",
     "test/helper.rb",
     "test/test_xbel.rb",
     "test/wikipedia.xbel",
     "xbel.gemspec"
  ]
  s.homepage = %q{http://xbel.monkey-patch.me}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Ruby API for XBEL based on Nokogiri.}
  s.test_files = [
    "test/helper.rb",
     "test/test_xbel.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<riot>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
    else
      s.add_dependency(%q<riot>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
    end
  else
    s.add_dependency(%q<riot>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
  end
end

