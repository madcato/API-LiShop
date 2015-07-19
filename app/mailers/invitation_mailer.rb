class InvitationMailer < ActionMailer::Base
  default from: "invitation@lishopapp.com"
  
  def invitation_email(toEmail, api_key)
    # TODO Transform api_key in a file attachment with the format ant type of the lishop import api_key bundle format.
    @api_key = api_key
    
    # attachments['filename.jpg'] = File.read('/path/to/filename.jpg')
    
    # encoded_content = SpecialEncode(File.read('/path/to/filename.jpg'))
    # attachments['filename.jpg'] = {
    #   mime_type: 'application/x-gzip',
    #   encoding: 'SpecialEncoding',
    #   content: encoded_content
    # }
    
    mail(to: toEmail, subject: "Invitation to share a shopping list for LiShop app")
  end
end
