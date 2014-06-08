require 'json'

module Jekyll
  class RoutesGenerator < Generator
    def generate(site)
      routes_input = File.join(site.source, '_routes.yml')
      routes = YAML.load_file routes_input

      index_page = site.pages.detect{|p| p.name == 'index.html'}

      routes.each_key do |route_name|
        if route_name != '/'
          site.static_files << Jekyll::RoutePage.new(site, site.dest, route_name, 'index.html', index_page.destination(site.dest))
        end
      end
    end
  end

  class RoutePage < StaticFile
    def initialize(site, dest, dir, name, index_path)
      @index_path = index_path
      @route_dir_path = File.join(dest, dir)
      @route_file_path = File.join(dest, dir, 'index.html')
      super(site, dest, dir, name)
    end

    def write(site_dest)
      index_page_content = File.read @index_path
      FileUtils.mkpath(@route_dir_path) if !File.directory? @route_dir_path
      route_file = File.new(@route_file_path, 'w')
      route_file.write index_page_content
      route_file.close
      begin
        super(dest)
      rescue
      end

      true
    end
  end
end