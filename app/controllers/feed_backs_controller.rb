class FeedBacksController < ApplicationController
  before_action 'authen_user'
  add_breadcrumb "Home", :root_path
  add_breadcrumb "FeedBack", :feed_backs_path

  def show
    sum_feed_back = Feedback.sum(:rating)
    total_feed_back = Feedback.count
    @rating = (sum_feed_back.to_f/total_feed_back.to_f).to_f
    @feed_backs = Feedback.all.paginate(page: params[:page], per_page: 10)
  end
end
