class BaseError < StandardError
  attr_reader :error

  def code
    raise NotImplementedError
  end

  def status
    raise NotImplementedError
  end

  def to_json
    {error: {message: error, code: code, status: status}}
  end
end