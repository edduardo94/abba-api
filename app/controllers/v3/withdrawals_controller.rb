class V3::WithdrawalsController < RestController
  def withdrawal_params
      attributes = model_attributes
      attributes.delete :id
      params.permit attributes
  end

  def searchable_attributes
      [:id]
  end

  def changeStatus
    if get_resource.update(params.permit(:status))
        after_update(get_resource)
        head :ok
    else
        json_response(get_resource, :unprocessable_entity)
    end
end

  def responseSerializer(object, action = :index)
      if action == :show
          Admin::WithdrawalSerializer.new(object)
      elsif action == :index
          object.as_json(:include => [:user, :bank_account ])
      end
  end
end
