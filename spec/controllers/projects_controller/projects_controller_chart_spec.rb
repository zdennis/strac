require File.dirname(__FILE__) + '/../../spec_helper'

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
