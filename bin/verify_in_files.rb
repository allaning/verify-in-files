require 'json'
require_relative 'options'
require_relative 'util/and'
require_relative 'util/or'
require_relative 'util/has'
require_relative 'util/not'

module VerifyInFiles

  # Reads file containing verification critera and checks against
  # input files
  class Verifier
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

    # Get target file name
    def get_target_file_name
      unless @options.target == ""
        @target = @options.target
      end
      if @target == nil
        puts "\nMust specify target file(s)."
        exit
      end

      if @target.include? ','
        # Multiple files specified
        @target = @target.split ','
        @target.each do |file|
          unless File.exists?(file)
            puts "Cannot find file: #{file}"
            exit
          end
        end
      else
        # Only one file specified
        unless File.exists?(@target)
          puts "Cannot find file: #{@target}"
          exit
        end
      end
    end

    # Get verification criteria
    def get_criteria
      unless @options.criteria_file == ""
        @top = read_checks_and_rules( @options.criteria_file )
      end
      if @top == nil
        puts "\nInvalid verification criteria specified."
        exit
      end
    end

    # Get application parameters
    def get_params
      @options = Options.new
      @options.parse_args
    end

    # Run rules against target file(s)
    def run
      self.get_params
      self.get_target_file_name
      self.get_criteria

      unless @top == nil
        if @target.kind_of? String
          @top.run @target
          puts "PASS" if @top.result == true
        end
      end
    end

  end
end

verify = VerifyInFiles::Verifier.new
verify.run

