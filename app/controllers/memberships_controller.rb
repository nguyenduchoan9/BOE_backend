class MembershipsController < ApplicationController
  before_action 'authen_user'

  def new
    @membership = Membership.new
  end

  def show
    @memberships = Membership.search(params[:term]).paginate(page: params[:page], per_page: 10)
  end

  def create
    @membership = Membership.new membership_params
    @membership.save
    redirect_to memberships_path
  end

  def edit
    @membership = Membership.find params[:id]
  end

  def update
    @membership = Membership.find params[:membership][:id]
    @membership.update_attributes(level: params[:membership][:level], mark_boundary: params[:membership][:mark_boundary], discount_rate: params[:membership][:discount_rate])
    redirect_to memberships_path
  end

  private
  def membership_params
    params.require(:membership).permit :id, :level, :discount_rate, :mark_boundary
  end
end
