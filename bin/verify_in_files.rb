require 'json'
require_relative 'util/options'
require_relative 'util/abstract_criteria_factory'

module VerifyInFiles

  # Reads file containing verification critera and checks against
  # input files
  class Verifier
    @@DEBUG = true

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
        factory = AbstractCriteriaFactory.new
        @top = factory.read_checks_and_rules( @options.criteria_file )
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
          # TODO: Process results
        end
        # TODO: Process multiple target files
      end
    end

  end
end

verify = VerifyInFiles::Verifier.new
verify.run

