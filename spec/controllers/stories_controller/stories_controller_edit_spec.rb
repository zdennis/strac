require File.dirname(__FILE__) + '/../../spec_helper'

describe StoriesController, '#edit' do
  def get_edit
    get :edit, :project_id => @project.id, :id => @story.id
  end
  
  before do
    @user = stub_login_for StoriesController
    @project = mock_model(Project)
    @story = mock_model(Story)
    @stories = stub("stories", :find => nil)
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
    @project.stub!(:stories).and_return(@stories)
    StoryPresenter.stub!(:new)
  end

  describe "when a project can't be found" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(nil)
    end
    
    it "redirects to access_denied" do
      get_edit
      response.should redirect_to("/access_denied.html")
    end
  end  
  
  it "finds the requested story" do
    @project.should_receive(:stories).and_return(@stories)
    @stories.should_receive(:find).with(@story.id.to_s, :include => :tags)
    get_edit
  end
  
  it "makes a StoryPresenter with a the requested Story available to the view" do
    @stories.stub!(:find).and_return(@story)
    StoryPresenter.should_receive(:new).with(:story => @story).and_return("story presenter")
    get_edit
    assigns[:story].should == "story presenter"
  end
  
  describe StoriesController, 'html request' do
    it "renders the 'edit' template" do
      get_edit
      response.should render_template('edit')
    end
  end
  
  describe StoriesController, 'xhr request' do
    it "renders the 'edit.js.rjs' template" do
      xhr :get, :edit, :project_id => '1', :id => '2'
      response.should render_template('stories/edit')
    end
  end
end
