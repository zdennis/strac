require File.dirname(__FILE__) + '/../../spec_helper'

describe StoriesController, '#show' do
  def xhr_get_show
    xhr :get, :show, :project_id => @project.id, :id => @story.id
  end
  
  before do
    @user = stub_login_for StoriesController
    @story = mock_model(Story, :comments => nil)
    @stories = mock("stories collection", :find => @story)
    @project = mock_model(Project, :stories => @stories)
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
  end

  it "finds and assigns the @project for the requested story" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id.to_s, @user).and_return(@project)
    xhr_get_show
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
      xhr_get_show
    end
  end

  it "assigns @story to a requested story" do
    @project.should_receive(:stories).and_return(@stories)
    @stories.should_receive(:find).with(@story.id.to_s, :include => [:tags, :comments]).and_return(@story)
    xhr_get_show
    assigns[:story].should == @story
  end
  
  it "assigns @comments to the story's comments" do
    @story.should_receive(:comments).and_return("story comments")
    xhr_get_show
    assigns[:comments].should == "story comments"
  end

  it "renders the stories/show template" do
    xhr_get_show
    response.should render_template("stories/show")
  end
end

