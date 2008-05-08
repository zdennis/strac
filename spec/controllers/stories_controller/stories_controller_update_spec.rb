require File.dirname(__FILE__) + '/../../spec_helper'

describe StoriesController, '#update' do
  def put_update(attrs={})
    put :update, {:project_id => @project.id, :id => @story.id, :story => @story_params}.merge(attrs)
  end

  def xhr_put_update(attrs={})
    xhr :put, :update, {:project_id => @project.id, :id => @story.id, :story => @story_params}.merge(attrs)
  end
  
  before do
    @user = stub_login_for StoriesController
    @story = mock_model(Story, :update_attributes => true, :summary => "foo")
    @stories = stub("stories", :find => @story)
    @project = mock_model(Project, :stories => @stories)
    @story_params = { 'summary' => 'foo' }
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
  end

  it "finds and assigns the @project for the requested story" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id.to_s, @user).and_return(@project)
    put_update
    assigns[:project].should == @project
  end
  
  describe "when a project can't be found" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(nil)
    end
    
    it "redirects to access_denied.html on an html request" do
      put_update
      response.should redirect_to("/access_denied.html")
    end
    
    it "tells the user they don't have access on an xhr request" do
      page = mock("page")
      controller.expect_render(:update).and_yield(page)
      page.should_receive(:replace_html).with(:error, "You don't have access to do that or the resource doesn't exist.")
      page.should_receive(:hide).with(:notice)
      page.should_receive(:show).with(:error)
      page.should_receive(:visual_effect).with(:appear, :error)
      page.should_receive(:delay).with(5).and_yield
      page.should_receive(:visual_effect).with(:fade, :error)
      xhr_put_update
    end

  end  
  
  it "finds the requested story" do
    @project.should_receive(:stories).and_return(@stories)
    @stories.should_receive(:find).with(@story.id.to_s, :include => :tags).and_return(@story)
    put_update
  end
  
  it "assigns @story" do
    @stories.stub!(:find).and_return(@story)
    put_update
    assigns[:story].should == @story
  end
  
  it "updates the story" do
    @story.should_receive(:update_attributes).with(@story_params)
    put_update
  end
  
  describe StoriesController, "updating the story successfully" do
    before do
      @story.stub!(:update_attributes).and_return(true)
    end
    
    describe StoriesController, 'html request' do
      it "redirects to the story_path" do
        put_update
        response.should redirect_to(story_path(@project, @story))
      end
      
      it "sets a flash[:notice] message" do
        put_update
        flash[:notice].should_not be_nil
      end
    end
  
    describe StoriesController, 'xhr request' do
      it "renders the 'update.js.rjs' template" do
        xhr_put_update
        response.should render_template('stories/update.js.rjs')
      end
    end
  end
  
  describe StoriesController, "failing to update the story" do
    before do
      @story.stub!(:update_attributes).and_return(false)
    end
    
    describe StoriesController, 'html request' do
      it "renders the 'edit' template" do
        put_update
        response.should render_template('edit')
      end
    end
  
    describe StoriesController, 'xhr request' do
      before do
        Status.stub!(:find).and_return([])
        Priority.stub!(:find).and_return([])
      end
      
      it "renders the 'edit.js.rjs' template" do
        xhr_put_update
        response.should render_template('stories/edit.js.rjs')
      end

      it "finds all statuses and assigns them to @statuses" do
        statuses = [mock_model(Status, :name => "a"), mock_model(Status, :name => "b")]
        Status.should_receive(:find).with(:all).and_return(statuses)
        xhr_put_update
        assigns[:statuses].should == [[], [statuses.first.name, statuses.first.id ], [statuses.last.name, statuses.last.id]]
      end
    
      it "finds all priorities and assigns them to @priorities" do
        priorities = [mock_model(Priority, :name => "foo"), mock_model(Priority, :name => "bar")]
        Priority.should_receive(:find).with(:all).and_return(priorities)
        xhr_put_update
        assigns[:priorities].should == [[], [priorities.first.name, priorities.first.id], [priorities.last.name, priorities.last.id]]
      end
    end

  end
end
