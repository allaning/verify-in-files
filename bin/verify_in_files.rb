module VerifyInFiles

  # Reads file containing verification critera and checks against
  # input files
  class Verifier
    @@DEBUG = true

    # Creates object based on hash key
    def create( hash, parent )
      if hash.has_key? 'And'
        puts "And" if @@DEBUG
        check = And.new
        parent.rules << check
        process( hash['And'], check )
      elsif hash.has_key? 'Or'
        puts "Or" if @@DEBUG
        check = Or.new
        parent.rules << check
        process( hash['Or'], check )
      elsif hash.has_key? 'Has'
        puts " Has: #{hash['Has']}" if @@DEBUG
        rule = Has.new( hash['Has'] )
        parent.rules << rule
      elsif hash.has_key? 'Not'
        puts " Not: #{hash['Not']}" if @@DEBUG
        rule = Not.new( hash['Not'] )
        parent.rules << rule
      end
    end

    # Parse the json object
    def process( json, parent )
      if json.kind_of? Array
        json.each { |obj| process obj, parent }
      elsif json.kind_of? Hash
        create( json, parent )
      end
    end

    # Read the file containing verification criteria
    def read_checks_and_rules( file_name )
      return unless file_name.kind_of?(String)
      return unless File.exists?( file_name )

      if file_name.include?( ".json" )
        require 'json'
        result = JSON.parse( File.read(file_name) )
        top = And.new
        puts "\nParse JSON" if @@DEBUG
        process( result, top )
        top
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
