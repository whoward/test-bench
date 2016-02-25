module TestBench
  class NullObject < BasicObject
    def self.build
      new
    end

    def class
      ::TestBench::NullObject
    end

    def method_missing *;
      nil
    end

    def respond_to? *;
      true
    end

    module NullAttribute
      refine Class do
        def null_attr *attr_names
          attr_writer *attr_names

          attr_names.each do |attr_name|
            ivar = "@#{attr_name}".freeze

            define_method attr_name do
              instance_variable_get ivar or
                instance_variable_set ivar, NullObject.new
            end
          end
        end
      end
    end
  end
end
