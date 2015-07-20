class InvitationMailer < ActionMailer::Base
  default from: "invitation@lishopapp.com"
  
  def invitation_email(toEmail, api_key)
    # Transform api_key in a file attachment with the format ant type of the lishop import api_key bundle format.
    @api_key = api_key
    
    encoded_content = JSON.generate({api_key: api_key})
    attachments['invitation.lishopApiKey'] = {
      mime_type: 'application/json',
      # encoding: 'text',
      content: encoded_content
    }

    mail(to: toEmail, subject: "Invitation to share a shopping list for LiShop app")
  end
end
