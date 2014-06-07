require 'json'

class RouteMappingDataProcessor < Sprockets::Processor
  def initialize(*args)
    @routes_input = File.expand_path('_routes.yml')
    super
  end

  def evaluate(context, locals)
    routes = YAML.load_file @routes_input
    parsed_routes = Hash.new
    routes = routes.each_key {|key| parsed_routes['/' + key.sub(/^\//, '')] = routes[key]}

    data.gsub('{{route_mapping_data}}', parsed_routes.to_json)
  end
end

Sprockets.register_preprocessor 'application/javascript', RouteMappingDataProcessor
