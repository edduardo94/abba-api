class V3::ProductsController < RestController
    include Rails.application.routes.url_helpers
    before_action :set_resource, only: [:show, :destroy, :update]
    before_action :set_product, only: [:imageUpload, :addStock, :updateStock, :deleteStock]

    def searchable_attributes
        [:description, :slug]
    end
    
    def resource_index_query
        resource_class.includes([:category, :subcategory]).with_attached_images
    end

    def set_resource(resource = nil)
        resource ||= resource_class.with_attached_images.find(params[:id])
        instance_variable_set("@#{resource_name}", resource)
    end

    def responseSerializer(object, action = :index)
        if action == :index
            object.as_json(:include => [:category, :subcategory])
        elsif action == :show
            serialize = Admin::ProductSerializer.new(object)
            productHash = serialize.to_hash
            productHash[:images] = parserImages(object)
            productHash
        else 
            Admin::ProductSerializer.new(object)
        end
    end

    def parserImages(object)
        if object.images.attached?
            object.images.map do |file|
                url = rails_blob_url(file)
                {:url => url, :signed_id => file.blob.signed_id}
            end
        else
            []
        end
    end

    def after_create(object)
        if params.key?(:grid_ids)
            params[:grid_ids].each do |grid_id|
                GridsProduct.create(:grid_id => grid_id, :product_id => object.id)
            end
        end
    end

    def addStock
        @product.stocks.create(params.permit(:product_id,:quantity,:grid_variation_id))
    end

    def updateStock
        stock = @product.stocks.find(params[:id])
        stock.update(params.permit(:product_id,:quantity,:grid_variation_id))
    end

    def deleteStock
        stock = @product.stocks.find(params[:id])
        stock.destroy
    end

    def product_params
        attributes = model_attributes
        attributes.delete :id
        attributes = attributes.push(images: [])
        params.permit attributes
    end

    private
    
    def set_product
        @product = resource_class.with_attached_images.find(params[:product_id])
    end
end
