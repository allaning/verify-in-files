require 'json'
require 'optparse'

module VerifyInFiles

  # Create verification instances
  class Factory
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


  end
end

