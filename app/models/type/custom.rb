module Type
  class Custom < ActiveModel::Type::Value
    def initialize(wraps:, in: {}, out: :itself.to_proc, **args)
      @wrapped_type = wraps
      @in = binding.local_variable_get(:in)
      @out = out

      super(**args)
    end

    def type
      :custom
    end

    def cast_value(value)
      @in.each do |type, transform|
        if value.is_a?(type)
          return transform.call(value)
        end
      end

      value
    end

    def deserialize(value)
      cast_value(@wrapped_type.deserialize(value))
    end

    def serialize(value)
      @wrapped_type.serialize(@out.call(value))
    end
  end
end
