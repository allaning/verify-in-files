module VerifyInFiles

  # Reads file containing verification critera and checks against
  # input files
  class Verifier

    # Read the file containing verification criteria
    def read_checks_and_rules( file_name )
      return unless file_name.kind_of?(String)
      return unless File.exists?( file_name )

      if file_name.include?( ".json" )
        require 'json'
        JSON.parse( File.read(file_name) )
      elsif file_name.match( /.*\.yml$|.*\.yaml$/ )
        require 'yaml'
        YAML::load( File.read(file_name) )
      end
    end

    # Read from cmd line params
    def get_criteria
      unless ARGV[0] == nil
        criteria = ARGV[0]
        @top = read_checks_and_rules( criteria )
      end
    end

  end
end
