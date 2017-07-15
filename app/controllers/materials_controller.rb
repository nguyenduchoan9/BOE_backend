class MaterialsController < ApplicationController
  before_action 'authen_user'
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Materials", :materials_path

  def create
    @material = Material.new material_params
    @material.available = true
    @material.save
    redirect_to materials_path
  end

  def show
    if !params[:term].nil? && params[:term] != ''
      @materials = Material.search(params[:term]).paginate(page: params[:page], per_page: 10)
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @material = Material.new
    add_breadcrumb "New Material"
  end

  def update_status
    respond_to do |format|
      format.json {
        @material = Material.find params[:id]
        if @material.available.nil?
          @material.update available: false
        end
        @material.update available: !@material.available
        render nothing: ''
      }
    end
  end

  def edit
    @material = Material.find params[:id]
    add_breadcrumb @material.name
  end

  def update
    @material = Material.find params[:material][:id]
    @material.update_attributes(material_params)
    redirect_to action: 'show'
  end

  private
  def material_params
    params.require(:material).permit :id, :name, :available
  end
end
