class V3::GridsController < RestController
    def grid_params
        attributes = model_attributes
        attributes.delete :id
        params.permit attributes
    end

    def searchable_attributes
        [:name]
    end

    def responseSerializer(object, action = :index)
        if action == :index
            object.as_json()
        else
            Admin::GridSerializer.new(object)
        end
    end
end
