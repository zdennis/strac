require File.dirname(__FILE__) + '/../spec_helper'

describe TagsController, '#auto_complete' do
  def get_auto_complete
    get :auto_complete, :tag => @tag
  end
  
  before do
    stub_login_for TagsController
    @tag = "MY_TAG"
    Tag.stub!(:find)
  end
  
  it "finds and assigns all of the tags for the given :tag parameter" do
    Tag.should_receive(:find).with(:all, :conditions => "name LIKE '%#{@tag}%'").and_return(:found_tags)
    get_auto_complete
    assigns[:tags].should == :found_tags
  end
  
  it "renders the tags/auto_complete template without a layout" do
    get_auto_complete
    response.should render_template("tags/auto_complete")
    
    controller.expect_render(:layout => false)
    get_auto_complete
  end
  
end
