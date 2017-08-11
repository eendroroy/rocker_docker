module DockerizeRails
  module DockerCommands
    module DockerBuild
      def self.build_rails
        build_docker_image(
          "#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::RAILS_DIRECTORY_NAME}/Dockerfile",
          "#{DRConfig.application_name}_rails"
        )
        puts " ==> Image >#{Helpers.get_name(:rails, :image)}< built successfully".green
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      def self.build_mysql
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'mysql'
          build_docker_image(
            "#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::MYSQL_DIRECTORY_NAME}/Dockerfile",
            "#{DRConfig.application_name}_mysql"
          )
        end
        puts " ==> Image >#{Helpers.get_name(:mysql, :image)}< built successfully".green
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      def self.build_postgres
        if DRConfig.linked_database? && DRConfig.databases[DRConfig.application_env] == 'postgresql'
          build_docker_image(
            "#{Constants::CONFIG_DIRECTORY_NAME}/#{Constants::PG_DIRECTORY_NAME}/Dockerfile",
            "#{DRConfig.application_name}_postgres"
          )
        end
        puts " ==> Image >#{Helpers.get_name(:postgres, :image)}< built successfully".green
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      def self.build_docker_image(dockerfile, repo)
        image = Docker::Image.build_from_dir(
          '.',
          dockerfile: dockerfile
        )
        image.tag(repo: repo, tag: DRConfig.application_env)
        puts "Image '#{repo}:#{DRConfig.application_env}' build success".green
        0
      rescue Docker::Error::NotFoundError => exception
        puts
        puts exception.to_s.red
        puts
        1
      end

      class << self
        private :build_docker_image
      end
    end
  end
end
