require File.dirname(__FILE__) + '/../test_helper'
require 'invitations_controller'

# Re-raise errors caught by the controller.
class InvitationsController; def rescue_action(e) raise e end; end

class InvitationsControllerTest < Test::Unit::TestCase
  fixtures :all

  def setup
    @controller = InvitationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_create
    Invitation.destroy_all
    @emails = ActionMailer::Base.deliveries
    @emails.clear
    
    login_as :joe
    
    post :create, 'project_id' => projects(:project1).id, 
      'email_addresses' => "foo@bar.com, bar@baz.com, baz@outtaideas.com",
      'email_body' => "whattup? do my work for me"
    
    assert_redirected_to project_path(projects(:project1))
    
    assert_equal 3, @emails.size, "did not send an email to each to address"
    
    assert_equal ["foo@bar.com"], @emails[0].to, "email 0 sent to wrong address"
    assert_match projects(:project1).name, @emails[0].subject
    assert_match projects(:project1).name, @emails[0].body
    assert_match "whattup? do my work for me", @emails[0].body
    assert_match login_url(:code => Invitation.find_by_recipient("foo@bar.com").code), @emails[0].body
    
    assert_equal ["bar@baz.com"], @emails[1].to, "email 1 sent to wrong address"
    assert_match projects(:project1).name, @emails[1].subject
    assert_match projects(:project1).name, @emails[1].body
    assert_match "whattup? do my work for me", @emails[1].body
    assert_match login_url(:code => Invitation.find_by_recipient("bar@baz.com").code), @emails[1].body
    
    assert_equal ["baz@outtaideas.com"], @emails[2].to, "email 2 sent to wrong address"
    assert_match projects(:project1).name, @emails[2].subject
    assert_match projects(:project1).name, @emails[2].body
    assert_match "whattup? do my work for me", @emails[2].body
    assert_match login_url(:code => Invitation.find_by_recipient("baz@outtaideas.com").code), @emails[2].body
  end
end
