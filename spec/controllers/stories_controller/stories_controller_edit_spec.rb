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
    Status.stub!(:find).with(:all).and_return([])
    Priority.stub!(:find).with(:all).and_return([])
  end

  it "finds and assigns the @project for the requested story" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id.to_s, @user).and_return(@project)
    get_edit
    assigns[:project].should == @project
  end

  it "finds and assigns statuses" do
    statuses = [ mock_model(Status, :name => "Foo"), mock_model(Status, :name => "Baz") ]
    Status.should_receive(:find).with(:all).and_return(statuses)
    get_edit
    assigns[:statuses].should == [ [], ["Foo", statuses.first.id], ["Baz", statuses.last.id] ]
  end
  
  it "finds and assigns priorities" do
    priorities = [ mock_model(Priority, :name => "Baz"), mock_model(Priority, :name => "Bar") ]
    Priority.should_receive(:find).with(:all).and_return(priorities)
    get_edit
    assigns[:priorities].should == [ [], ["Baz", priorities.first.id], ["Bar", priorities.last.id] ]
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
