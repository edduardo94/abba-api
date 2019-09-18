# frozen_string_literal: true

module V1
  class CategoriesController < ApplicationController
    skip_before_action :authorize_request, only: %i[show index index_subcategory]

    def show
      categories = Category.where(active: true)
      json_response(categories)
    end

    def index
      category = Category.find_by(id: category_params[:id])
      json_response(category)
    end

    def index_subcategory
      subcategory = Subcategory.find_by(id: category_params[:id])
      json_response(subcategory)
    end

    private

    def category_params
      params.permit(:id)
    end
  end
end
