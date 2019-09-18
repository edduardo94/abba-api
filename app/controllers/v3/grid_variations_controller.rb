class V3::GridVariationsController < RestController
    def grid_variation_params
        attributes = model_attributes
        attributes.delete :id
        params.permit attributes
    end

    def resource_index_query
        resource_class.where("grid_id = ?", params[:grid_id])
    end
end
