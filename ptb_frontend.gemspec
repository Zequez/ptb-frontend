Gem::Specification.new do |s|
  s.authors = ['Ezequiel Adrián Schwartzman']
  s.email = 'zequez@gmail.com'
  s.name = 'ptb_frontend'
  s.version = "0.1.1"
  s.date = '2014-06-01'
  s.summary = 'Front end website generator for Playtime For The Buck'
  s.files = [
    "Gemfile"
  ]
  s.license = 'GPLv2'
  s.add_dependency 'psych', '>= 2.0.5'
  s.add_dependency 'sass'
  s.add_dependency 'uglifier'
  s.add_dependency 'coffee-script'
  s.add_dependency 'ejs'
  s.add_dependency 'jekyll', '= 1.5.0'
  s.add_dependency 'jekyll-assets'
  s.add_dependency 'bourbon'
  s.add_dependency 'rake'
end