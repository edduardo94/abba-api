class RestController < ActionController::API
    include Response
    include ExceptionHandler

    before_action :set_resource, except: [:index, :create]

    def index
        resources = resource_index_query.where(query_statement, query_params).order(order_args)
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

    def create
        set_resource(resource_class.new(resource_params))
        if get_resource.save
            after_create(get_resource)
            json_response(get_resource, :created)
        else
            json_response(get_resource.errors, :unprocessable_entity)
        end
    end

    def show
        json_response(responseSerializer(get_resource, :show))
    end

    def destroy
        get_resource.destroy
        after_destroy()
        head :no_content
    end
    
    def update
        if get_resource.update(resource_params)
            after_update(get_resource)
            json_response(responseSerializer(get_resource, :update), :ok)
        else
            json_response(get_resource, :unprocessable_entity)
        end
    end

    private

    def resource_name
        @resource_name ||= self.controller_name.singularize
    end

    def resource_class
        @resource_class ||= resource_name.classify.constantize
    end

    def set_resource(resource = nil)
        resource ||= resource_class.find(params[:id])
        instance_variable_set("@#{resource_name}", resource)
    end

    def get_resource
        instance_variable_get("@#{resource_name}")
    end

    def resource_index_query
        resource_class
    end

    def query_statement
        query = params.permit(:search)
        searchable = searchable_attributes()
        
        return nil if !query.has_key?(:search) or searchable.length == 0
        
        conditions = []
        
        searchable.each do | attribute |
            conditions.push("#{attribute} LIKE :search")
        end
        
        return conditions.join(" OR ") if conditions.length > 1

        conditions.join("")
    end

    def query_params
        params.permit(:search)
        {:search => "%#{params[:search]}%"}
    end

    def searchable_attributes
        []
    end

    def page_params
        params.permit(:page, :per_page)
            .with_defaults({:page=>1, :per_page=>10})
    end
    
    def order_args
        order = params.permit(:order_by, :sort)
            .with_defaults({:order_by=> :created_at, sort: :desc})
        "#{order[:order_by]} #{order[:sort]}"
    end

    def resource_params
        @resource_params ||= self.send("#{resource_name}_params")
    end

    def model_attributes
        resource_class.attribute_names.map{|s| s.to_sym} - [:created_at, :updated_at]
    end

    def responseSerializer(object, action = :index)
        object
    end

    def after_create(object)
    end

    def after_update(object)
    end

    def after_destroy
    end
end
