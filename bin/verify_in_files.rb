require 'json'
require_relative 'util/util'
require_relative 'util/options'
require_relative 'util/abstract_criteria_factory'

module VerifyInFiles

  # Reads file containing verification critera and checks against
  # input files
  class Verifier
    @@DEBUG = true

    def initialize(target=nil, criteria=nil)
      @options ||= Options.new
      @target = get_target_file_name target unless target == nil
      @top = get_criteria criteria unless criteria == nil
    end

    # Get target file name
    def get_target_file_name( target=nil )
      @options.target = target unless target == nil
      unless @options.target == ""
        target = @options.target
      end
      if target == nil
        puts "\nMust specify target file(s)."
        exit
      end

      if target.include? ','
        # Multiple files specified
        target = target.split ','
        target.each do |file|
          unless File.exists?(file)
            puts "Cannot find file: #{file}"
            exit
          end
        end
      else
        # Only one file specified
        unless File.exists?(target)
          puts "Cannot find file: #{target}"
          exit
        end
      end
      puts "Target file(s): #{target}" if @@DEBUG
      target
    end

    # Get verification criteria
    def get_criteria( file=nil )
      @options.critera_file = file unless file == nil
      puts "Criteria file: #{@options.criteria_file}" if @@DEBUG
      unless @options.criteria_file == ""
        factory = AbstractCriteriaFactory.new
        top = factory.read_checks_and_rules( @options.criteria_file )
      end
      if top == nil
        puts "\nInvalid verification criteria specified."
        exit
      end
      top
    end

    # Get application parameters
    def get_params
      @options ||= Options.new
      @options.parse_args
    end

    # Run rules against target file(s)
    def run
      self.get_params
      @target ||= self.get_target_file_name
      @top ||= self.get_criteria

      unless @top == nil
        result = true
        if @target.kind_of? String
          puts "Processing file: #{@target}"
          lines = Util.get_file_as_array( @target )
          @top.run lines
          result = @top.result
        else
          @target.each do |file|
            print "Processing file: #{file}... "
            lines = Util.get_file_as_array( file )
            @top.reset_rule_results
            @top.run lines
            result = false unless @top.result == true
            if @top.result
              puts "[Pass]"
            else
              puts "[Fail]"
            end
          end
        end

        if result == true
          puts "PASS"
        else
          puts "FAIL"
        end
      else
        puts "Error loading verification criteria from: #{@options.criteria_file}"
      end
    end

  end
end

verify = VerifyInFiles::Verifier.new
verify.run

