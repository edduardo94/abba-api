class ActivationSerializer < ActiveModel::Serializer
  attributes :id  
  belongs_to :order
end
