require 'json'
require 'optparse'
require_relative 'and'
require_relative 'or'
require_relative 'has'
require_relative 'not'

module VerifyInFiles

  # Create verification instances
  class AbstractCriteriaFactory
    @@DEBUG = true

    # Receives a hash and creates an object based on the hash key
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

    # Parses an object heirarchy based on whether function receives
    # an array (i.e. multiple objects at given level) or
    # a hash (i.e. single object at given level)
    def process( tier, parent )
      if tier.kind_of? Array
        # Recurse for each object
        tier.each { |obj| process(obj, parent) }
      elsif tier.kind_of? Hash
        create( tier, parent )
      end
    end

    # Check if a string is in JSON format
    def is_json?( str )
      begin
        !!JSON.parse(str)
      rescue
        false
      end
    end

    # Validates format of input string
    def is_valid( str )
      if self.is_json?(str)
        true
      else
        puts "\nERROR: Not in JSON format" unless self.is_json?(str)
        false
      end
    end

    # Read the file containing verification criteria
    def read_checks_and_rules( file_name )
      return unless file_name.kind_of?(String)
      return unless File.exists?( file_name )

      if File.extname(file_name) == ".json"
        json = File.read(file_name)
        if is_valid(json)
          puts "\nReading JSON file: #{file_name}"
          result = JSON.parse( json )
          top = And.new
          process( result, top )
          puts "\n#{display_yaml(top)}" if @@DEBUG
        end
        top
      elsif File.extname(file_name) == ".yml" || File.extname(file_name) == ".yaml"
        require 'yaml'
        YAML::load( File.read(file_name) )
      end
    end

    # Show object in YAML
    def display_yaml( obj )
      require 'yaml'
      puts YAML::dump(obj)
    end

  end
end

