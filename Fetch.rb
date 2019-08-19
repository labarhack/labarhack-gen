require 'open-uri'
require 'uri'
require 'yaml'

def yml_read(uri)
  begin
     repo_list_content = open(uri,"rb") do |f| f.read end
     YAML::load(repo_list_content)
  rescue OpenURI::HTTPError
     puts "!!! fail to fetch <#{uri}>"
     {} 
  rescue Errno::ENOENT
     puts "!!! error on opening <#{uri}>"

  end

end

class Fetch < Middleman::Extension
  option :repo_list,"","url of the file which contains the list of repository to scan which contains the list of published documentation which should be proceed !!"
  
  def initialize(app, options_hash = {}, &block)
    super
      list = options.repo_list #{"vagrant-nomad-consul" => ["README.md"]}

    app.before do
      puts '/// before ///'
    end

    app.ready do
      puts '~~~ Fetching repo list from github'
      repo_list = yml_read list
      repo_list["github_repos"].each do |repo|
        puts "~~~ from : <#{repo}> getting:"
        url = "https://raw.githubusercontent.com/labarhack/#{repo}/master/publish-list.yml"
        doc_list = yml_read url
        unless doc_list.empty? 
          doc_list["publish"].each do |doc| 
              url_doc = "https://raw.githubusercontent.com/labarhack/#{repo}/master/#{doc}"
              fname = "./source/articles/#{repo}-#{File.basename url_doc,File.extname(url_doc) }.html#{File.extname url_doc}"
              open(fname, 'wb') do |file|
                file << open(url_doc).read
                puts "~~~ Got : <#{fname}>"
              end
          end
        end
      end
      puts '/// ready ///'
    end

    app.before_build do |_builder|
      puts '/// before_build ///'
    end

    app.after_build do |_builder|
      puts '/// after_build ///'
    end
  end

  def after_configuration
    puts '/// after_configuration ///'
  end
end

::Middleman::Extensions.register(:fetch_from_github, Fetch)
