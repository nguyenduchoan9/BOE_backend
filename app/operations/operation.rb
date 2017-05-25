class Operation
  include Support::Authen
  include Support::Policy
  include Support::Validate
  attr_accessor :params, :headers, :user

  def initialize(params, headers, user = nil)
    @params = params
    @headers = headers
    @user = user
  end

  def execute
    begin
      authenticate!
      authorize_action!
      process
    rescue ActiveRecord::RecordNotFound => _
      raise NotFound
    end
  end

  private
  class << self
    attr_accessor :require_authen, :require_authorize

    def require_authen!
      self.require_authen = true
    end

    def require_authorize!
      self.require_authorize = true
    end
  end

  def process
    raise NotImplementedError
  end
end
