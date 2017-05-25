module Support
  module Validate
    def validator_finder
      "#{self.class.to_s}Validator".constantize
    end

    def validate(model)
      validator = validator_finder.new(model)
      validator.validate(params)
      validator.errors.each do |key, value|
        model.errors.add(key, value) unless model.errors.keys.include?(key)
      end
      model.errors.full_messages.blank?
    end

    def validate!(model)
      validator = validator_finder.new(model)
      raise ValidateError.new(validator.errors.full_messages) unless validator.validate(params)
    end
  end
end
