require File.dirname(__FILE__) + '/../spec_helper'

describe StoryPresenter do
  before do
    @story = mock_model(Story)
    @presenter = StoryPresenter.new :story => @story
  end
  
  describe 'delegations' do
    it_delegates :class, :id, :new_record?, :to_param,
                 :bucket_id, :comments, :description, :errors, :points, :priority_id, 
                 :project, :responsible_party_type_id, :status_id, :summary, :tag_list,
                 :on => :presenter, :to => :story
  end
  
  describe '#possible_statuses' do
    it "returns the possible statuses for the story" do
      statuses = [ mock_model(Status, :name => "Foo"), mock_model(Status, :name => "Baz") ]
      Status.should_receive(:find).with(:all).and_return(statuses)
      @presenter.possible_statuses.should == [ [], ["Foo", statuses.first.id], ["Baz", statuses.last.id] ]
    end
  end

  describe '#possible_priorities' do
    it "returns the possible priorities for the story" do
      priorities = [ mock_model(Priority, :name => "Foo"), mock_model(Priority, :name => "Baz") ]
      Priority.should_receive(:find).with(:all).and_return(priorities)
      @presenter.possible_priorities.should == [ [], ["Foo", priorities.first.id], ["Baz", priorities.last.id] ]
    end
  end

end

