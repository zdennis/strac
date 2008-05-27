require File.dirname(__FILE__) + '/../../spec_helper'

describe ProjectsController, '#workspace' do
  def get_workspace(params={})
    get :workspace, params.reverse_merge(:id => @project.id)
  end
  
  before do
    @user = mock_model(User)
    login_as @user
  end
  
  describe 'when the user has access to the project' do
    before do
      @project = Generate.project
      @incomplete_stories = []
      story_count = 3
      story_count.times do |i|
        @incomplete_stories << Generate.story(:project => @project) 
        @incomplete_stories.last.update_attribute(:position, story_count - i)
      end
      @sorted_incomplete_stories = @incomplete_stories.sort_by{ |story| story.position }    
      ProjectPermission.stub!(:find_project_for_user).and_return(@project)
    end
    
    it "assigns @stories to the project's incomplete stories" do
      get_workspace
      assigns(:stories).should == @sorted_incomplete_stories
    end
    
    describe "when there are completed stories" do
      before do
        @completed_stories = []
        3.times { @completed_stories << Generate.story(:project => @project, :status => Status.complete) }
      end
    
      it "does not include completed stories" do
        get_workspace
        assigns(:stories).should == @sorted_incomplete_stories
      end
    end
    
  end
  
  describe 'when the user does not have access to the project' do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(nil)
    end
    
    it "redirects to access_denied" do
      get_workspace
      response.should redirect_to("/access_denied.html")
    end
  end
end