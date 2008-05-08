require File.dirname(__FILE__) + '/../../spec_helper'

describe StoriesController, '#update_points' do
  def xhr_update_points
    xhr :put, :update_points, :project_id => @project.id, :id => @story.id, :story => { :points => @points }
  end
  
  before do
    @user = stub_login_for StoriesController
    @story = mock_model(Story, :summary => "FooBaz", :update_attribute => nil)
    @stories = mock("stories", :find => @story)
    @project = mock_model(Project, :stories => @stories)
    @points = '11'
    
    @page = stub("page", :delay => nil, :visual_effect => nil, :call => nil,
      :replace_html => nil, :replace => nil, :hide => nil, :show => nil )

    controller.expect_render(:update).and_yield(@page)
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
  end
  
  it "finds the project for the requested story" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id.to_s, @user).and_return(@project)
    xhr_update_points
  end  

  it "updates the points on the requested story" do
    @project.should_receive(:stories).and_return(@stories)
    @stories.should_receive(:find).with(@story.id.to_s).and_return(@story)
    @story.should_receive(:update_attribute).with(:points, @points)
    xhr_update_points
  end
  
  describe "when the update is successful" do
    before do
      @story.stub!(:update_attribute).and_return(true)
      @story.stub!(:points).and_return(9)
    end

    it "tells the user the story was updated" do
      @page.should_receive(:replace_html).with(:notice, %|"FooBaz" was successfully updated.|)
      @page.should_receive(:hide).with(:error)
      @page.should_receive(:show).with(:notice)
      @page.should_receive(:visual_effect).with(:appear, :notice)
      @page.should_receive(:delay).with(5).and_yield
      @page.should_receive(:visual_effect).with(:fade, :notice)
      xhr_update_points
    end

    it "updates the story points when there are story points" do
      @page.should_receive(:replace_html).with("story_#{@story.id}_points", 9)
      xhr_update_points
    end

    it "updates the story points when there are no story points" do
      @story.stub!(:points).and_return(nil)
      @page.should_receive(:replace_html).with("story_#{@story.id}_points", "&infin;")
      xhr_update_points
    end

    it "updates the project summary" do
      @page.should_receive(:replace).with(:project_summary, :partial => "projects/summary", :locals => { :project => @project })
      xhr_update_points
    end

    it "redraws the workspace velocity markers" do
      @page.should_receive(:call).with("Strac.Iteration.drawWorkspaceVelocityMarkers")
      xhr_update_points
    end
  end

  describe "when the update fails" do
    before do
      @story.stub!(:update_attribute).and_return(false)
    end

    it "tells the user the story failed to update" do
      @page.should_receive(:replace_html).with(:error, %|"FooBaz" was not updated.|)
      @page.should_receive(:hide).with(:notice)
      @page.should_receive(:show).with(:error)
      @page.should_receive(:visual_effect).with(:appear, :error)
      @page.should_receive(:delay).with(5).and_yield
      @page.should_receive(:visual_effect).with(:fade, :error)
      xhr_update_points
    end
  end

end
