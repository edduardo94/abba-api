class V3::SubcategoriesController < RestController
    def subcategory_params
        attributes = model_attributes
        attributes.delete :id
        params.permit attributes
    end

    def searchable_attributes
        [:name]
    end

    def responseSerializer(object, action = :index)
        if action == :show
            Admin::SubcategorySerializer.new(object)
        else
            object
        end
    end
end
