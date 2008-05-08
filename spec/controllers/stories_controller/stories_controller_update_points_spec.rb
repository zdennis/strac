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
    @page = stub("page")
    controller.expect_render(:update).and_yield(@page)
    @remote_project_renderer = stub("remote project renderer", 
      :update_project_summary => nil, 
      :update_story_points => nil, 
      :render_notice => nil,
      :render_error => nil,
      :draw_current_iteration_velocity_marker => nil
    )
    RemoteProjectRenderer.stub!(:new).and_return(@remote_project_renderer)    
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
    end
    
    it "builds a RemoteProjectRenderer for the project" do
      RemoteProjectRenderer.should_receive(:new).with(:page => @page, :project => @project).and_return(@remote_project_renderer)
      xhr_update_points
    end

    it "tells the renderer to render a notice telling the user the update was successful" do
      @remote_project_renderer.should_receive(:render_notice).with(%|"#{@story.summary} was successfully updated."|)
      xhr_update_points
    end
    
    it "tells the renderer to update the story points" do
      @remote_project_renderer.should_receive(:update_story_points).with(@story)
      xhr_update_points
    end
    
    it "tells the renderer to update the project's summary" do
      @remote_project_renderer.should_receive(:update_project_summary)
      xhr_update_points
    end
    
    it "tells the renderer to draw the current iteration velocity marker" do
      @remote_project_renderer.should_receive(:draw_current_iteration_velocity_marker)
      xhr_update_points
    end
  end

  describe "when the update fails" do
    before do
      @story_update.stub!(:failure).and_yield(@story)
    end

    it "builds a RemoteProjectRenderer for the project" do
      RemoteProjectRenderer.should_receive(:new).with(:page => @page, :project => @project).and_return(@remote_project_renderer)
      xhr_update_points
    end
    
    it "tells the renderer to render an error telling the user the update was not successful" do
      @remote_project_renderer.should_receive(:render_error).with(%("#{@story.summary}" was not successfully updated.))
      xhr_update_points
    end
  end

end
