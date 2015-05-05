
require 'Filigree'
include Filigree

def build_adt_variant(attributes)
  Class.new() do
    extend Filigree::Destructurable
    @fields = attributes
    attr_accessor *@fields

    def self.fields
      @fields
    end

    def initialize(*args)
      if args.size != self.class.fields.size
        raise ArgumentError, "Expected #{@fields.size}, given #{args.size} arguments"
      end

      self.class.fields.zip(args) do |attr, val|
        send "#{attr}=", val
      end
    end
    
    def destructure(_)
      self.class.fields
    end
    
    def self.inherited(subclass)
      error = "Illegal attempt to subclass #{self} with
      #{subclass}"
      raise RuntimeError, error
    end

    def self.method_added(method)
      error = "cannot add or change method #{method} to closed"
      error += " class #{self}"
      raise RuntimeError, error
    end
  end
end
  
def define_adt(name, variant_array)
  ## for each variant in the array,
  ## build a class
  variant_array.each do |var|    
    ## define the class, assign it to 'adt_variant'
    ## create the variant
    Object.const_set(var[0], build_adt_variant(var[1]))
  end
  true
end



define_adt("Family",
          [["Bob", [:age, :hobbies]],
           ["Alice", [:age, :sports]]])


the_bob = Bob.new(42, "All Sports")

#Bob.new()

## errors on both!
# class Bobby < Bob
# end

# class Bob
#   def by
#     puts "goodbye!"
#   end
# end


match the_bob do
  with(Bob.(age, hobbies)) do
    puts "Bob likes #{hobbies}"
  end
  with(Alice.(age, sports)) do
    puts "it's alice!"
  end
end
