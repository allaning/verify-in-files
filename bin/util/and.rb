require_relative 'check'

module VerifyInFiles

  # Similar to a boolean-AND, all checks within this class
  # must equate to true for result to be true.
  class And < Check

    def to_s
      str = "And: {"
      rules.each { |rule| str += "#{rule.to_s}," }
      str += "}"
    end

  end end
