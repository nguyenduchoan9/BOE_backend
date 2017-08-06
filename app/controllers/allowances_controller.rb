class AllowancesController < ApplicationController
  before_action 'authen_user'
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Allowances", :allowances_path

  def show
    if params[:term]
      @allowances = Allowance.where('DATE(created_at) = ?', params[:term]).paginate(page: params[:page], per_page: 10)
    end
  end
end
