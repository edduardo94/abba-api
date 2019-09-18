module V2
  class ProductsController < ApplicationController
    
    def show
      @product = Product.with_attached_images.find_by(id: product_params[:id])
      serialize = Admin::ProductSerializer.new(@product)
      productHash = serialize.to_hash
      productHash[:images] = parserImages(@product)
      json_response(productHash)
    end

    def parserImages(object)
      if object.images.attached?
        index = 0
        object.images.map do |file|
          url = rails_blob_url(file)
          item = { url: url, index: index, blob_id: file[:blob_id] }
          index += 1
          item
        end
      else
        []
      end
    end
  end
end