require 'json'
require_relative 'options'
require_relative 'factory'
require_relative 'util/and'
require_relative 'util/or'
require_relative 'util/has'
require_relative 'util/not'

module VerifyInFiles

  # Reads file containing verification critera and checks against
  # input files
  class Verifier
    @@DEBUG = true

    # Read the file containing verification criteria
    def read_checks_and_rules( file_name )
      return unless file_name.kind_of?(String)
      return unless File.exists?( file_name )

      factory = Factory.new
      if File.extname(file_name) == ".json"
        json = File.read(file_name)
        if factory.is_valid(json)
          puts "\nReading JSON file: #{file_name}"
          result = JSON.parse( json )
          top = And.new
          factory.process( result, top )
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
#verify.run

