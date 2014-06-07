require 'sprockets'
require 'listen'
require 'json'

cache_dir = File.expand_path('.routes_cache')
routes_input = File.expand_path('_routes.yml')
routes_output = File.expand_path('.routes_cache/routes/mapping_data.js')
routes_output_path = File.dirname(routes_input)

FileUtils.mkpath(routes_output_path) unless Dir.exists? routes_output_path
Sprockets.append_path cache_dir

compile = Proc.new do |modified, added, removed|
  puts 'Regenerating routes!'
  routes = YAML.load_file routes_input
  parsed_routes = Hash.new
  routes = routes.each_key {|key| parsed_routes['/' + key.sub(/^\//, '')] = routes[key]}
  File.write routes_output, "PTB.Routes.mappingData = #{parsed_routes.to_json};"
end

Listen.to(File.dirname(routes_input), force_polling: true, filter: /.yml$/)
      .change(&compile)
      .start

compile.call(nil, nil, nil)