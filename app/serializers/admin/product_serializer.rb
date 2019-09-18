class Admin::ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes [
    :id, 
    :description, 
    :price, 
    :promotional_price, 
    :office_price, 
    :category_id, 
    :category,
    :subcategory_id, 
    :subcategory,
    :weight, 
    :width, 
    :height, 
    :depth, 
    :slug, 
    :favorite, 
    :active,
    :grid_ids,
    :grid
  ]

  has_many :stocks

  def grid
    if entity.grids
      grid = entity.grids.first
      if grid
        attributes = grid.attributes
        attributes[:grid_variations] = grid.grid_variations
        attributes
      end
    end
  end

  def grid_ids
    if entity.grids
      entity.grids.map {|grid| grid.id}
    end
  end

  private

  def entity
    if object.instance_of? Product
      object
    elsif object.object.instance_of? Product
      object.object
    else
      {}
    end
  end
end