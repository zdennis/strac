require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectManager, 'constructor' do
  before do
    @user = mock_model(User)
  end
  
  it "finds the project for the passed in project_id and user" do
    ProjectManager.should_receive(:get_project_for_user).with('11', @user)
    ProjectManager.new '11', @user
  end
end

