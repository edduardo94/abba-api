class V3::OrdersController < RestController
    before_action :set_resource, only: [:show, :destroy, :update, :changeStatus, :changeTracking]
    before_action :set_orders, only: [:index]

    def searchable_attributes
        [:id]
    end

    def order_params
        attributes = model_attributes
        attributes.delete :id
        params.permit attributes
    end

    def set_orders
        resources = resource_index_query.where(query_statement, query_params).where(order_type: [1,2]).order(order_args)
        perPage = page_params[:per_page].to_i
        
        if perPage < 0
            @data = responseSerializer(resources)
        else
            @data = resources.paginate(page: page_params[:page], per_page: page_params[:per_page])
        end

        response = {
            meta: {
                pagination: {
                    page: page_params[:page].to_i,
                    perPage: page_params[:per_page].to_i,
                    totalRows: resources.length
                }
            },
            data: responseSerializer(@data, :index)
        }
        json_response(response)
    end

    def responseSerializer(object, action = :index)
        if action == :index
            object.as_json(:include => [:user])
        else 
            Admin::OrderSerializer.new(object)
        end
    end

    def changeStatus
        if get_resource.update(params.permit(:status))
            after_update(get_resource)
            head :ok
        else
            json_response(get_resource, :unprocessable_entity)
        end
    end

    def changeTracking
        if get_resource.update(params.permit(:tracking_code))
            after_update(get_resource)
            head :ok
        else
            json_response(get_resource, :unprocessable_entity)
        end
    end
end
