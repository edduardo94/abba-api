# frozen_string_literal: true

module V1
  class DirectUploadsController < ActiveStorage::DirectUploadsController
    # Should only allow null_session in API context, so request is JSON format
    skip_before_action :verify_authenticity_token, raise: false
  
  end
end
