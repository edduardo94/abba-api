# frozen_string_literal: true

class V3::UsersController < RestController
  def user_params
    attributes = model_attributes
    attributes.delete :id
    attributes.delete :password_digest
    attributes = attributes.push(:password)
    attributes = attributes.push(:password_confirmation)
    params.permit attributes
  end

  def searchable_attributes
    %i[name email cpf]
  end

  def activate_user
    sql = " INSERT INTO orders
      (id, value, user_id, frete_value, frete_days, frete_type, payment_type, address_id, status, created_at, updated_at, order_type, tracking_code, points_released, commission_released, installments)
      VALUES('#{SecureRandom.uuid}', 0.00, #{get_resource.id}, 0.00, 0, NULL, '2', #{get_resource.addresses.find_by(is_principal: true).id}, 3, '#{DateTime.now.to_formatted_s(:db)}', '#{DateTime.now.to_formatted_s(:db)}', 3, NULL, NULL, NULL, 1);"
    ActiveRecord::Base.connection.execute(sql)
    after_update(get_resource)
    head :ok
  end

  def inactivate_user
    orders = get_resource.orders.where(created_at:
        Time.now.beginning_of_month..Time.now.end_of_month).where(order_type: 3)
    if orders.destroy_all
      after_update(get_resource)
      head :ok
    else
      json_response(get_resource, :unprocessable_entity)
    end
  end

  def update_point
    if get_resource.point.update(params.permit(:value))
      after_update(get_resource)
      head :ok
    else
      json_response(get_resource, :unprocessable_entity)
    end
  end

  def responseSerializer(object, action = :index)
    if action == :index
      object
    else
      Admin::UserSerializer.new(object)
    end
  end
end
