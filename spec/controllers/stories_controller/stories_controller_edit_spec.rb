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
  end

  it "finds and assigns the @project for the requested story" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id.to_s, @user).and_return(@project)
    get_edit
    assigns[:project].should == @project
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
  
  it "assigns @story" do
    story = stub("story")
    @stories.stub!(:find).and_return(story)
    get_edit
    assigns[:story].should == story
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
