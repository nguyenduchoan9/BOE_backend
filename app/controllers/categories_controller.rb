class CategoriesController < ApplicationController
  before_action 'authen_user'
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Categories", :categories_path

  def create
    @category = Category.new category_params
    @category.status = true
    @category.save
    redirect_to categories_path
  end

  def show
    if !params[:term].nil? && params[:term] != ''
      @categories = Category.search(params[:term]).paginate(page: params[:page], per_page: 10)
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @category = Category.new
    add_breadcrumb "New Category"
  end

  def edit
    @category = Category.find params[:id]
    add_breadcrumb "Category "+ params[:id]
  end

  def update
    @category = Category.find params[:category][:id]
    @category.update_attributes(category_params)
    redirect_to action: 'show'
  end

  private
  def category_params
    params.require(:category).permit :id, :category_name, :status
  end
end
