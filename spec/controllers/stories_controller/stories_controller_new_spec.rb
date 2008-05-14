require File.dirname(__FILE__) + '/../../spec_helper'

describe StoriesController, '#new' do
  def xhr_get_new
    xhr :get, :new, :project_id => @project.id
  end
  
  before do
    stub_login_for StoriesController
    @stories = mock("stories collection", :build => nil)
    @project = mock_model(Project, :stories => @stories)
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
    StoryPresenter.stub!(:new)
  end

  it "finds and assigns the @project for the requested story" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id.to_s, @user).and_return(@project)
    xhr_get_new
    assigns[:project].should == @project
  end

  describe "when a project can't be found" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(nil)
    end
    
    it "tells the user they don't have access" do
      page = mock("page")
      controller.expect_render(:update).and_yield(page)
      page.should_receive(:replace_html).with(:error, "You don't have access to do that or the resource doesn't exist.")
      page.should_receive(:hide).with(:notice)
      page.should_receive(:show).with(:error)
      page.should_receive(:visual_effect).with(:appear, :error)
      page.should_receive(:delay).with(5).and_yield
      page.should_receive(:visual_effect).with(:fade, :error)
      xhr_get_new
    end
  end

  it "makes a StoryPresenter with a new Story available to the view" do
    @project.should_receive(:stories).and_return(@stories)
    @stories.should_receive(:build).with().and_return("newly_built_story")
    StoryPresenter.should_receive(:new).with(:story => "newly_built_story").and_return("story presenter")
    xhr_get_new
    assigns[:story].should == "story presenter"
  end

  it "renders the stories/new template" do
    xhr_get_new
    response.should render_template("stories/new")
  end
end