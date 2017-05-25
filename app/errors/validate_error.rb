class ValidateError < BaseError
  def initialize(error = [])
    @error = error
  end

  def self.init_record(record)
    error = new(record.errors.full_messages)
    error
  end

  def status
    422
  end

  def code
    'UNPROCESSABLE ENTITY'
  end
end
