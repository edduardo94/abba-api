# frozen_string_literal: true

class PointSerializer < ActiveModel::Serializer
  attributes :id, :value, :user_id, :networking_points, :total_points
end
