require 'test_helper'

class InvitaionMailerTest < ActionMailer::TestCase
  test "invite" do
    api_key = 'adlkfhaldsjflkasd'
    
    email = InvitationMailer.invitation_email('dani_vela@me.com', api_key).deliver
    
    assert_not ActionMailer::Base.deliveries.empty?
 
    # Test the body of the sent email contains what we expect it to
    assert_equal ['invitation@lishopapp.com'], email.from
    assert_equal ['dani_vela@me.com'], email.to
    assert_equal 'Invitation to share a shopping list for LiShop app', email.subject
    assert_equal email.attachments.count, 1
  end
end
