# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{teanalyzer}
  s.version = "0.9.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jorg Jenni}]
  s.date = %q{2011-06-07}
  s.description = %q{An analyzer for keyboard typing efforts}
  s.email = %q{jorg.jenni@jennius.co.uk}
  s.extra_rdoc_files = [%q{README}, %q{lib/core/finger_parameters.rb}, %q{lib/core/hand_parameters.rb}, %q{lib/core/hands_parameters.rb}, %q{lib/core/key.rb}, %q{lib/core/keyboard.rb}, %q{lib/core/rows_parameters.rb}, %q{lib/core/triad.rb}, %q{lib/keyboards/uk-keyboard}, %q{lib/parameters.rb}, %q{lib/teanalyzer.rb}]
  s.files = [%q{Gemfile}, %q{Gemfile.lock}, %q{HOWTO}, %q{Manifest}, %q{README}, %q{Rakefile}, %q{lib/core/finger_parameters.rb}, %q{lib/core/hand_parameters.rb}, %q{lib/core/hands_parameters.rb}, %q{lib/core/key.rb}, %q{lib/core/keyboard.rb}, %q{lib/core/rows_parameters.rb}, %q{lib/core/triad.rb}, %q{lib/keyboards/uk-keyboard}, %q{lib/parameters.rb}, %q{lib/teanalyzer.rb}, %q{spec/hand_parameters_spec.rb}, %q{spec/key_spec.rb}, %q{spec/keyboard_spec.rb}, %q{spec/teanalyzer_spec.rb}, %q{spec/triad_spec.rb}, %q{teanalyzer.gemspec}]
  s.homepage = %q{https://github.com/Enceradeira/teanalyzer}
  s.rdoc_options = [%q{--line-numbers}, %q{--inline-source}, %q{--title}, %q{Teanalyzer}, %q{--main}, %q{README}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{teanalyzer}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{An analyzer for keyboard typing efforts}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
