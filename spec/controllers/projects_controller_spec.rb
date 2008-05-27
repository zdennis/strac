require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectsController, "#index" do
  def get_index(params={})
    get :index, params
  end
  
  before do
    @user = mock_model(User)
    login_as @user
    @projects = stub("projects")
    ProjectPermission.stub!(:find_all_projects_for_user).and_return(@projects)
  end
  
  it "asks the project manager for all projects for the current user" do
    ProjectPermission.stub!(:find_all_projects_for_user).with(@user).and_return(@projects)
    get_index
  end
  
  it "assigns @projects to the current user's projects" do
    get_index
    assigns[:projects].should == @projects
  end
  
  describe "when the request is an html request" do
    it "renders index template" do
      get_index
      response.should be_success
      response.should render_template('index')
    end
  end
end

describe ProjectsController, "#new" do
  before do
    @user = mock_model(User)
    login_as @user
    get :new
  end

  it "assigns an new project" do
    assigns[:project].should_not be_nil
    assigns[:project].should be_new_record
  end

  it "renders new template" do
    response.should be_success
    response.should render_template('new')
  end
end

describe ProjectsController, "#show" do
  def get_show(params={})
    get :show, params.reverse_merge(:id => @project.id)
  end

  before do
    @user = mock_model(User)
    @project = mock_model(Project)
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
    login_as @user
  end

  it "asks the ProjectPermission to find the requested project for the current user" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id.to_s, @user)
    get_show
  end
  
  describe "a user with proper privileges" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(@project)      
    end
    
    it "assigns the requested project" do
      get_show
      assigns[:project].should == @project
    end

    it "renders show template" do
      get_show
      response.should be_success
      response.should render_template('show')
    end
  end
  
  describe "a user without proper privileges" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(nil)
    end
    
    it "redirects to the 401 access denied page" do
      get_show
      response.should redirect_to("/access_denied.html")
    end
  end
end

describe ProjectsController, "#create" do
  def post_create(params={})
    post( :create, {:project => @project_params}.reverse_merge(params) )    
  end

  before do
    @user = mock_model(User)
    login_as @user
    @project_params = { :name => "Project Foo" }
    @project = mock_model(Project, :save => nil)
    Project.stub!(:new).and_return(@project)
  end

  it "builds a new Project" do
    Project.should_receive(:new).and_return(@project)
    post_create
  end
  
  it "assigns @project to the newly built project" do
    post_create
    assigns[:project].should == @project
  end
  
  it "saves the project" do
    @project.should_receive(:save)
    post_create
  end
  
  describe "when the project saves successfully" do
    before do
      @project.stub!(:save).and_return(true)
      @user.stub!(:projects).and_return([])
    end
    
    it "adds the project to the current user's list of projects" do
      @projects = []
      @user.should_receive(:projects).and_return(@projects)
      post_create
      @projects.should == [@project]
    end
    
    it "sets the flash[:notice] telling the user the project was created" do
      post_create
      flash[:notice].should == 'Project was successfully created.'
    end
    
    describe "when the request is an html request" do
      it "redirects to the project show path for the newly created project" do
        post_create
        response.should redirect_to(project_path(@project))
      end
    end
  end

  describe "when the project fails to save" do
    before do
      @project.stub!(:save).and_return(false)
    end

    describe "when the request is an html request" do
      it "renders the projects/new template" do
        post_create
        response.should render_template("projects/new")
      end
    end
  end
end

describe ProjectsController, '#update' do
  def put_update(params={})
    put :update, {:id => @project.id, :project => @project_params, :users => @users_params}.merge(params)
  end
  
  before do
    @user = mock_model(User)
    login_as @user
    @project = mock_model(Project)
    @project_params = { 'name' => "Project HRM" }
    @users_params = [1,2,3,4]
    ProjectPermission.stub!(:find_project_for_user)
  end
  
  it "finds the requested project for the current user" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id.to_s, @user)
    put_update
  end
  
  describe "the project is found" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(@project)
      @project.stub!(:update_attributes).with(@project_params)
    end
    
    it "assigns @project" do
      put_update
      assigns[:project].should == @project
    end    

    it "updates the project" do
      @project.should_receive(:update_attributes).with(@project_params)
      put_update
    end
    
    describe "when the project updates successfully" do
      before do
        @project.stub!(:update_attributes).and_return(true)
        @project.stub!(:update_members)
      end

      it "updates the project's members" do
        @project.should_receive(:update_members).with(@users_params)
        put_update
      end

      it "sets the flash[:notice] telling the user the project was updated" do
        put_update
        flash[:notice].should == 'Project was successfully updated.'
      end

      it "redirects to the project page" do
        put_update
        response.should redirect_to(project_path(@project))
      end
    end
    
    describe "when the project fails to update" do
      before do
        @project.stub!(:update_attributes).with(@project_params).and_return(false)
      end

      it "renders the projects/edit template" do
        put_update
        response.should render_template("projects/edit")
      end
    end
  end  
end

describe ProjectsController, '#edit' do
  def get_edit(params={})
    get :edit, params.reverse_merge(:id => @project.id)
  end
  
  before do
    @user = mock_model(User)
    login_as @user
    @project = mock_model(Project)
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
  end
  
  it "finds the requested project for the current user" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id.to_s, @user)
    get_edit
  end
  
  describe "when the user has access to the request project" do
    it "assigns @project to the requested project" do
      get_edit
      assigns[:project].should == @project
    end

    it "renders 'projects/edit' template" do
      get_edit
      response.should be_success
      response.should render_template('edit')
    end
  end
  
  describe "when the user doesn't have access to the project" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(nil)
    end
    
    it "redirects to the access denied page" do
      get_edit
      response.should redirect_to("/access_denied.html")
    end
  end
end

describe ProjectsController, '#destroy' do
  def delete_destroy(params={})
    delete :destroy, params.reverse_merge(:id => @project.id)
  end
  
  before do
    @user = mock_model(User)
    login_as @user
    @project = mock_model(Project, :destroy => nil)
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
  end

  it "finds the requested project for the current user" do
    ProjectPermission.find_project_for_user(@project.id.to_s, @user)
    delete_destroy
  end
  
  describe "when the user has access to the request project" do
    it "assigns @project to the requested project" do
      delete_destroy
      assigns[:project].should == @project
    end
    
    it "destroys the project" do
      @project.should_receive(:destroy)
      delete_destroy
    end
    
    describe "when the request is an html request" do
      it "redirects the user to the projects index page" do
        delete_destroy
        assert_redirected_to projects_path    
      end    
    end
  end
  
  describe "when the user doesn't have access to the project" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(nil)
    end
    
    it "redirects to the access denied page" do
      delete_destroy
      response.should redirect_to("/access_denied.html")
    end
  end
end

describe ProjectsController, '#workspace' do
  def get_workspace(params={})
    get :workspace, params.reverse_merge(:id => @project.id)
  end
  
  before do
    @user = mock_model(User)
    login_as @user
  end
  
  describe 'when the user has access to the project' do
    before do
      @project = Generate.project
      @incomplete_stories = []
      story_count = 3
      story_count.times do |i|
        @incomplete_stories << Generate.story(:project => @project) 
        @incomplete_stories.last.update_attribute(:position, story_count - i)
      end
      @sorted_incomplete_stories = @incomplete_stories.sort_by{ |story| story.position }    
      ProjectPermission.stub!(:find_project_for_user).and_return(@project)
    end
    
    it "assigns @stories to the project's incomplete stories" do
      get_workspace
      assigns(:stories).should == @sorted_incomplete_stories
    end
    
    describe "when there are completed stories" do
      before do
        @completed_stories = []
        3.times { @completed_stories << Generate.story(:project => @project, :status => Status.complete) }
      end
    
      it "does not include completed stories" do
        get_workspace
        assigns(:stories).should == @sorted_incomplete_stories
      end
    end
    
  end
  
  describe 'when the user does not have access to the project' do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(nil)
    end
    
    it "redirects to access_denied" do
      get_workspace
      response.should redirect_to("/access_denied.html")
    end
  end
end

describe ProjectsController, '#chart' do
  before do
    @user = mock_model(User)
    login_as @user
  end
  
  describe 'when the user has access to a project with a completed iteration and stories completed in the current iteration' do
    before do
      @project = Generate.project :members => [@user]

      @incomplete_story = Generate.story :points => 75, :project => @project
      
      @iteration1_snapshot = Generate.snapshot(
        :total_points => 100,
        :completed_points => 0,
        :remaining_points => 100
      )
      @iteration1 = Generate.iteration :project => @project,
        :started_at => 2.weeks.ago, 
        :ended_at => 1.1.weeks.ago,
        :snapshot => @iteration1_snapshot
      @iteration1_story1 = Generate.story :bucket => @iteration1, :points => 15, :status => Status.complete
      
      @iteration2_snapshot = Generate.snapshot(
        :total_points => 100,
        :completed_points => 15,
        :remaining_points => 85
      )
      @iteration2 = Generate.current_iteration :project => @project,
        :started_at => 1.weeks.ago,
        :snapshot => @iteration2_snapshot
      @iteration2_story1 = Generate.story :bucket => @iteration2, :points => 10, :status => Status.complete
      
      ProjectPermission.stub!(:find_project_for_user).and_return(@project)
    end
    
    it "should create a Gchart with the project history" do
      @gchart = mock("Gchart")
      Gchart.should_receive(:new).with({
        :legend=>["Total Points", "Total Points Completed", "Points Remaining", "Points Remaining Trend"], 
        :data=>[[100, 100, 100], [0, 15, 25], [100, 85, 75], [95.0, 85.0, 75.0]], 
        :axis_with_labels=>["x", "y"], 
        :axis_labels=>[[0, 1, "current"], [0, 17, 33, 50, 67, 83, 100]], 
        :size=>"600x200", 
        :bar_colors=>["0000FF", "00FF00", "a020f0", "551a8b"]
      }).and_return(@gchart)
      @gchart.should_receive(:send!).with(:fetch).and_return("the chart")
      
      get :chart, :id => @project.id
      
      @response.body.should == "the chart"
    end
  end
  
  
  describe 'when the user has access to a project with no completed iterations and a brand new current iteration' do
    before do
      @project = Generate.project :members => [@user]

      @incomplete_story = Generate.story :points => 100, :project => @project
      
      @iteration1_snapshot = Generate.snapshot(
        :total_points => 100,
        :completed_points => 0,
        :remaining_points => 100
      )
      @iteration1 = Generate.current_iteration :project => @project,
        :started_at => 2.weeks.ago,
        :snapshot => @iteration1_snapshot
      
      ProjectPermission.stub!(:find_project_for_user).and_return(@project)
    end
    
    it "should create a Gchart with the project history" do
      @gchart = mock("Gchart")
      Gchart.should_receive(:new).with({
        :legend=>["Total Points", "Total Points Completed", "Points Remaining"], 
        :data=>[[100, 100], [0, 0], [100, 100]], 
        :axis_with_labels=>["x", "y"], 
        :axis_labels=>[[0, "current"], [0, 17, 33, 50, 67, 83, 100]], 
        :size=>"600x200", 
        :bar_colors=>["0000FF", "00FF00", "a020f0"]
      }).and_return(@gchart)
      @gchart.should_receive(:send!).with(:fetch).and_return("the chart")
      
      get :chart, :id => @project.id
      
      @response.body.should == "the chart"
    end
  end
end
