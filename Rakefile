desc "Install some stuff needed that I didn't want to commit"
task :install do
  exec 'cd _assets/stylesheets && bourbon install'
end

desc 'Start Jekyll webserver watch'
task :watch do
  exec 'jekyll serve -w -P 9999'
end

desc 'Build Jekyll'
task :build do
  exec 'jekyll build'
end


task :default => :watch