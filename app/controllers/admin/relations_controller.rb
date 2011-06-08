class Admin::RelationsController < Admin::ResourceController

  before_filter :load_data, :only => :create

  def create
    @relation.relatable = @product
    @relation.related_to = Variant.find(params[:relation][:related_to_id]).product
    if @relation.save
      render :partial => "admin/products/related_products_table", :locals => {:product => @product}, :layout => false
    else
      render :text => @relation.errors.inspect
    end
  end

  private
  
    def load_data
      @product = Product.find_by_permalink(params[:product_id])
    end

end
