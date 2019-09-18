class V3::AttachmentsController < ActionController::API
    def destroy
        @blob = ActiveStorage::Blob.find_signed(params[:signed_id])
        @attachments = ActiveStorage::Attachment.where("blob_id = ?", @blob.id)

        @attachments.each do |attachment| 
            attachment.purge
        end

        head :no_content
    end
end