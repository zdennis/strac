require File.dirname(__FILE__) + '/../../spec_helper'

describe Project, "#iterations" do
  before do
    @project = Generate.project
  end

  it "can generate a dummy backlog iteration" do
    backlog = @project.iterations.backlog
    backlog.id.should be_nil
    backlog.name.should == "Backlog"
  end

  describe "returning the current iteration" do
    it "returns an iteration that started today and does not have an end date" do
      iteration = Generate.iteration :project => @project, :started_at => Time.now, :ended_at => nil
      @project.iterations.current.should == iteration      
    end
    
    it "returns an iteration that started before today and does not have an end date" do
      iteration = Generate.iteration :project => @project, :started_at => 1.weeks.ago, :ended_at => nil
      @project.iterations.current.should == iteration
    end
    
    it "does not return an iteration that has a start date" do
      iteration = Generate.iteration :project => @project, :started_at => 1.weeks.ago, :ended_at => Time.now
      @project.iterations.current.should be_nil

      @project.iterations.clear
      iteration = Generate.iteration :project => @project, :started_at => Time.now, :ended_at => 1.day.from_now
      @project.iterations.current.should be_nil
    end
  end

  it "can return the iteration with the second latest start date as the previous iteration" do
    @project.iterations.clear
    @previous_iteration = Generate.iteration :project => @project, :started_at => 2.weeks.ago, :ended_at => 1.weeks.ago
    current_iteration = Generate.iteration :project => @project, :started_at => Date.today, :ended_at => nil
    @project.iterations.previous.should == @previous_iteration
  end

  it "can find or build the current iteration" do
    now = Time.now
    Time.stub!(:now).and_return(now)
    current_iteration = Generate.iteration :project => @project, :started_at => 1.day.ago, :ended_at => nil
    @project.iterations.find_or_build_current.should == current_iteration
    
    @project.iterations.clear
    @project.iterations.should be_empty
    iteration = @project.iterations.find_or_build_current
    iteration.started_at.should == now
    iteration.ended_at.should be_nil
  end
end