class RepositoryGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  desc "This generator creates a repository for the model name
    given to it as an argument."

  gem "fig_leaf"

  def find_model
    begin
      File.open("app/models/#{file_name}.rb", "r") do |f|
        f.each_line do |line|
          @base_model = line if line.match(/\< ActiveRecord\:\:Base/)
        end
      end
    rescue
      puts "You need to generate the base model first. Please run 'rails generate model #{class_name}' and try again."
    end
  end

  def create_repository_file
    return unless @base_model
    create_file "app/repositories/#{file_name}_repository.rb", <<-FILE
class #{class_name}Repository < ActiveRecord::Base
  def base_model
    #{@base_model}
  end
end

    FILE

  end

  def alter_base_model
    # gsub_file "app/models/#{file_name}.rb", "< ActiveRecord::Base", ""
    inject_into_file "app/models/#{file_name}.rb", after: "class #{class_name} < ActiveRecord::Base" do
      <<-'RUBY'

  include StripActiveRecord

      RUBY
    end
  end
end
