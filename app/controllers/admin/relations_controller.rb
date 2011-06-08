class Admin::RelationsController < Admin::ResourceController

  before_filter :load_data, :only => :create

  # [todo] fix me!

  private
  
    def load_data
      @product = Product.find_by_permalink(params[:product_id])
    end

end
