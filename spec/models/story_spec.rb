require File.dirname(__FILE__) + '/../spec_helper'

describe Story do
  before do
    @story = Story.new
  end

  it "should be valid" do
    @story.summary = "story 1"
    @story.project_id = 1
    @story.should be_valid
  end

  it "belongs to a Bucket" do
    assert_association Story, :belongs_to, :bucket, Bucket
  end
  
  it "belongs to a Project" do
    assert_association Story, :belongs_to, :project, Project
  end

  it "belongs to a Status" do
    assert_association Story, :belongs_to, :status, Status
  end  
    
  it "belongs to a Priority" do
    assert_association Story, :belongs_to, :priority, Priority
  end
  
  describe "#responsible_party - polymorphic association" do
    it "associates with another model" do
      @user = Generate.user(:email_address => "some user")
      @project = Generate.project(:name => "Some Project")
      @story = Generate.story(:summary => "story summary", :responsible_party => @user)
      @story.responsible_party.should be(@user)
    end
  end
  
  it "should have many Time Entries" do
    assert_association Story, :has_many, :time_entries, TimeEntry, :as => :timeable
  end
  
  it "should have many Comments" do
    assert_association Story, :has_many, :comments, Comment, :as => :commentable
  end
  
  it "should have many Activities" do
    assert_association Story, :has_many, :activities, Activity, :as => :affected 
  end
  
  it "should require a summary" do
    assert_validates_presence_of @story, :summary
  end

  it "should require numeric points" do
    @story.points = "blah"
    assert_validates_numericality_of @story, :points
  end
  
  it "should require numeric position" do
    @story.position = "string"
    assert_validates_numericality_of @story, :position
  end
end


describe Story, "complete" do
  fixtures :statuses
  
  it "is incomplete if it does not have a status" do
    story = Story.new
    story.should be_incomplete
  end
  
  it "is incomplete if its status is defined" do
    story = Story.new :status => statuses(:defined)
    story.should be_incomplete
  end
  
  it "is incomplete if its status is in progress" do
    story = Story.new :status => statuses(:inprogress)
    story.should be_incomplete
  end
  
  it "is complete if its status is complete" do
    story = Story.new :status => statuses(:complete)
    story.should be_complete
  end
  
  it "is complete if its status is rejected" do
    story = Story.new :status => statuses(:rejected)
    story.should be_complete
  end
  
  it "is incomplete if its status is in blocked" do
    story = Story.new :status => statuses(:blocked)
    story.should be_incomplete
  end
end

describe Story, "when a story is completed" do
  before do
    @story = Generate.story
    @project = @story.project
  end
  
  describe "when there is a current iteration for the story's project" do
    before do
      @iteration = Generate.iteration :project => @project, :start_date => Date.yesterday, :end_date => nil      
    end
    
    it "assigns the story to the currently running iteration" do
      @story.bucket.should be_nil
      @story.status = Status.complete
      @story.save!
      @story.bucket.should == @iteration
    end
  end

  describe "when there is no current iteration for the story's project" do
    before do
      @project.iterations.clear
    end
    
    it "assigns the story to the currently running iteration" do
      @story.bucket.should be_nil
      @story.status = Status.complete
      @story.save!
      @story.bucket.should be_nil
    end
  end

end