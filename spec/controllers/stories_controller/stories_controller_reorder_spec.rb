require File.dirname(__FILE__) + '/../../spec_helper'

describe StoriesController, '#reorder' do
  def xhr_put_reorder(attrs={})
    xhr :put, :reorder, {:project_id => @project.id, "iteration_nil" => @story_ids}.merge(attrs)
  end
  
  before do
    stub_login_for StoriesController
    @project = mock_model(Project)
    @story_ids = [ "3", "2", "", "1"]
    @page = stub("page", :delay => nil, :visual_effect => nil, :replace_html => nil, :replace => nil, :hide => nil, :show => nil )
    Story.stub!(:import)
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
  end

  it "finds and assigns the @project for the requested story" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id.to_s, @user).and_return(@project)
    xhr_put_reorder
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
      xhr_put_reorder
    end
  end

  it "reorders the stories" do
    Story.should_receive(:import).with(
      [:id, :position], 
      [["3", 1], ["2", 2], ["1", 3]], 
      :on_duplicate_key_update => [:position],
      :validate => false
    )
    xhr_put_reorder
  end
  
  describe "when reordering the stories is successful" do
    before do
      controller.expect_render(:update).and_yield(@page)
    end

    it "tells the user the story was updated" do
      @page.should_receive(:replace_html).with(:notice, "Priorities have been successfully updated.")
      @page.should_receive(:hide).with(:error)
      @page.should_receive(:show).with(:notice)
      @page.should_receive(:visual_effect).with(:appear, :notice)
      @page.should_receive(:delay).with(5).and_yield
      @page.should_receive(:visual_effect).with(:fade, :notice)
      xhr_put_reorder
    end    
  end
  
  describe "when reordering the stories is not successful" do
    before do
      controller.expect_render(:update).and_yield(@page)
      Story.stub!(:import).and_raise(StandardError)
    end

    it "tells the user the story failed to update" do
      @page.should_receive(:replace_html).with(:error, "There was an error while updating priorities. If the problem persists, please contact technical support.")
      @page.should_receive(:hide).with(:notice)
      @page.should_receive(:show).with(:error)
      @page.should_receive(:visual_effect).with(:appear, :error)
      @page.should_receive(:delay).with(5).and_yield
      @page.should_receive(:visual_effect).with(:fade, :error)
      xhr_put_reorder
    end
  end
  
end