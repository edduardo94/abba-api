class V3::CategoriesController < RestController
    def category_params
        attributes = model_attributes
        attributes.delete :id
        params.permit attributes
    end

    def searchable_attributes
        [:name]
    end
end
