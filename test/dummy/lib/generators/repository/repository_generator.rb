class RepositoryGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  desc "This generator creates a repository for the model name
    given to it as an argument."

  def find_model
    begin
      File.open("app/models/#{file_name}.rb", "r") do |f|
        f.each_line do |line|
          puts line
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
end
