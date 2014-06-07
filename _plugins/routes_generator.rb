# module Jekyll
#   class RoutesGenerator < Generator
#     def generate(site)
#       years = {}
#       site.posts.each do |post|
#         if years.has_key?(post.date.year)
#           years[post.date.year] << {"url"=>post.url, "title"=>post.title}
#         else
#           years[post.date.year] = [{"url"=>post.url, "title"=>post.title}]
#         end
#       end

#       site.pages <<  ArchivesPage.new(site, site.source, "archives", "index.html", years)
#     end
#   end
# end