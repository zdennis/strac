require File.dirname(__FILE__) + '/../../spec_helper'

describe StoriesController, '#create' do
  def xhr_post_create
    post :create, :project_id => @project.id, :id => @story.id, :story => @story_params
  end
  
  before do
    @user = stub_login_for StoriesController
    @story = mock_model(Story, :save => nil)
    @stories = stub("stories", :build => @story)
    @project = mock_model(Project, :stories => @stories)
    @story_params = { 'summary' => 'foo' }
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
    Status.stub!(:find).and_return([])
    Priority.stub!(:find).and_return([])
  end

  it "finds and assigns the @project for the requested story" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id.to_s, @user).and_return(@project)
    xhr_post_create
    assigns[:project].should == @project
  end
  
  describe "when a project can't be found" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(nil)
    end
    
    it "redirects to access_denied" do
      xhr_post_create
      response.should redirect_to("/access_denied.html")
    end
  end

  it "builds and assigns a @story for the project" do
    @project.should_receive(:stories).and_return(@stories)
    @stories.should_receive(:build).with(@story_params).and_return(@story)
    xhr_post_create
    assigns[:story].should == @story
  end
  
  it "saves the story" do
    @story.should_receive(:save)
    xhr_post_create
  end

  describe "when the story saves successfully" do
    before do
      @story.stub!(:save).and_return(true)
    end

    it "renders the stories/create template" do
      xhr_post_create
      response.should render_template("stories/create")
    end
  end
  
  describe "when the story fails to save" do
    before do
      @story.stub!(:save).and_return(false)
    end

    it "renders the stories/new template" do
      xhr_post_create
      response.should render_template("stories/new")
    end
  end
end
