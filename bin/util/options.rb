require 'optparse'

module VerifyInFiles

  # Get application parameters (e.g. command line options)
  class Options

    attr_accessor :target, :criteria_file

    def initialize
      self.target = ""
      self.criteria_file = ""
    end

    def parse_args(argv = ::ARGV)
      opt_parser = OptionParser.new do |opt|

        opt.on("--file=[TARGET]",
               "File(s) to verify. Separate multiple files with commas (,)") do |file|
          self.target = file
        end
        opt.on("--rules=[RULES]",
               "File containing verification rules.") do |rules|
          self.criteria_file = rules
        end
        opt.on_tail("-h", "--help", "Show this message") do
          puts opt
          exit
        end

      end

      opt_parser.parse! argv
    end

  end
end

