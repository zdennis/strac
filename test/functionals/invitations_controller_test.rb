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
    login_as :joe
    
    post :create, 'project_id' => projects(:project1).id, 'email_addresses' => "foo@bar.com, bar@baz.com, baz@outtaideas.com"
    
    assert_redirected_to project_path(projects(:project1))
  end
end
