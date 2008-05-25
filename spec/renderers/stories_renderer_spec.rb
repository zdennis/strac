require File.dirname(__FILE__) + '/../spec_helper'

describe StoriesRenderer, '#add_to_story_list' do
  before do
    @page = mock("page")
    @renderer = StoriesRenderer.new @page
    
    @story = mock("story")
  end
  
  describe "when the story doesn't belong to a bucket" do
    before do
      @story.stub!(:bucket).and_return(nil)
    end

    it "adds the story to iteration_nil" do
      @page.should_receive(:insert_html).
        with(:bottom, "iteration_nil", :partial => 'list', :locals => { :stories => [ @story ] })
      
      @renderer.add_to_story_list(@story)
    end
  end
  
  describe "when the story belongs to a bucket" do
    before do
      @bucket = mock("bucket", :id => 917)
      @story.stub!(:bucket).and_return(@bucket)
    end

    it "adds the story to the bucket" do
      @page.should_receive(:insert_html).
        with(:bottom, "iteration_917", :partial => 'list', :locals => { :stories => [ @story ] })
      
      @renderer.add_to_story_list(@story)
    end
  end
end
