# frozen_string_literal: true

require 'correios-frete'

module V1
  class ProductsController < ApplicationController
    skip_before_action :authorize_request, only: %i[
      index calc_frete show_by_category
      show_by_subcategory show_all show show_favorites
    ]

    def show_by_category
      products = Product.category(product_params[:category_id]).where(active: true)
                        .left_outer_joins(:stocks).where('stocks.quantity > 0')
                        .group(:id).order(created_at: :desc)
      meta = { total_pages: products.length / 10 < 1 ? 1 : products.length / 10 + 1 }
      products = parserImagesArray(products.paginate(page: product_params[:page], per_page: 10))
      response = {
        products: products,
        meta: meta
      }
      json_response(response)
    end

    def show_by_subcategory
      products = Product.subcategory(product_params[:subcategory_id]).where(active: true)
                        .left_outer_joins(:stocks).where('stocks.quantity > 0')
                        .group(:id).order(created_at: :desc)
      meta = { total_pages: products.length / 10 < 1 ? 1 : products.length / 10 + 1 }
      products = parserImagesArray(products.paginate(page: product_params[:page], per_page: 10))

      response = {
        products: products,
        meta: meta
      }
      json_response(response)
    end

    def show_favorites
      
      products = Product.where(active: true).where(favorite: true)
                        .left_outer_joins(:stocks).where('stocks.quantity > 0')
                        .group(:id).order(created_at: :desc)                        
      meta = { total_pages: products.length / 10 < 1 ? 1 : products.length / 10 + 1 }
      products = parserImagesArray(products.paginate(page: product_params[:page], per_page: 10))

      response = {
        products: products,
        meta: meta
      }
      json_response(response)
    end

    def show_all
      products = Product.with_attached_images.where(active: true)
                        .left_outer_joins(:stocks).where('stocks.quantity > 0')
                        .group(:id).order(created_at: :desc)
      products = parserImagesArray(products.paginate(page: product_params[:page], per_page: 10))
      response = {
        products: products,
        meta: { total_pages: products.length / 10 > 1 ? 1 : products.length / 10 + 1 }
      }
      json_response(response)
    end

    def show
      @product = Product.with_attached_images.find_by(id: product_params[:id])
      serialize = Admin::ProductSerializer.new(@product)
      productHash = serialize.to_hash
      productHash[:images] = parserImages(@product)
      json_response(productHash)
    end

    def index
      @products = Product.filter(params.slice(:starts_with))
                         .where(active: true)
                         .left_outer_joins(:stocks).where('stocks.quantity > 0')
                         .order(created_at: :desc)
      json_response(@products)
    end

    def calc_frete
      @product = Product.find_by(id: frete_params[:product_id])
      @pacote = Correios::Frete::Pacote.new
      (1..frete_params[:quantity]).each do |_i|
        item = Correios::Frete::PacoteItem.new peso: @product.weight,
                                               comprimento: @product.depth,
                                               largura: @product.width,
                                               altura: @product.height
        @pacote.adicionar_item(item)
      end
      frete = Correios::Frete::Calculador.new cep_origem: '60711055',
                                              cep_destino: frete_params[:cep_destino],
                                              encomenda: @pacote
      servicos = frete.calcular :sedex, :pac
      json_response(servicos)
    end

    private

    def product_params
      params.permit(:category_id, :subcategory_id, :page, :id)
    end

    def frete_params
      params.permit(
        :product_id,
        :cep_destino,
        :selected_size,
        :stock_id,
        :quantity
      )
    end

    def parserImages(object)
      if object.images.attached?
        index = 0
        object.images.map do |file|
          url = rails_blob_url(file)
          item = { url: url, index: index, blob_id: file[:blob_id] }
          index += 1
          item
        end
      else
        []
      end
    end

    def parserImagesArray(array)
      prods = []
      array.each do |object|
        serialize = Admin::ProductSerializer.new(object)
        product_hash = serialize.to_hash
        product_hash[:images] = parserImages(object)
        prods.push(product_hash)
      end
      prods
    end
  end
end
