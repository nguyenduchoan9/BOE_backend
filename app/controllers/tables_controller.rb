class TablesController < ApplicationController
  before_action 'authen_user'

  def new
    @table = Table.new
  end

  def create
    @table = Table.new table_params
    @table.save
    redirect_to action: 'show'
  end

  def show
    @tables = Table.search(params[:term]).paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.json {render json: @tables}
      format.html
    end
  end

  def edit
    @table = Table.find params[:id]
    qrcode = RQRCode::QRCode.new(@table.table_number.to_s)
    png = qrcode.as_png(resize_gte_to: false,
                        resize_exactly_to: false,
                        fill: 'white',
                        color: 'black',
                        size: 600,
                        border_modules: 0,
                        module_px_size: 0)
    respond_to do |format|
      format.html {}
      format.png {
        send_data png, type: 'image/png'
      }
      format.json {
        filename = "table"+@table.id.to_s + ".png"
        send_data png.to_datastream, type: 'image/png', filename: filename
      }
    end
  end

  def update
    @table = Table.find params[:table][:id]
    @table.update_attributes(:table_number => params[:table][:table_number])
    redirect_to action: 'show'
  end

  private
  def table_params
    params.require(:table).permit :id, :table_number
  end
end

# qrcode = RQRCode::QRCode.new('http://localhost:3000/table'+@table.table_number.to_s)
# png = qrcode.as_png(resize_gte_to: false,
#                     resize_exactly_to: false,
#                     fill: 'white',
#                     color: 'black',
#                     size: 600,
#                     border_modules: 0,
#                     module_px_size: 0)
# png.save('app/assets/images/table'+@table.table_number.to_s+'.png', interlace: true)