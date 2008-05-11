require File.dirname(__FILE__) + '/../spec_helper'

describe TextileController, '#preview' do
  def get_preview
    get :preview, :textile => @textile
  end
  
  before do
    stub_login_for TextileController
    @textile = "blargy"
    @redcloth = mock("redcloth instance", :to_html => nil)
    RedCloth.stub!(:new).and_return(@redcloth)
  end
  
  it "transforms the passed in textile text into HTML and assigns it" do
    RedCloth.should_receive(:new).with(@textile).and_return(@redcloth)
    @redcloth.should_receive(:to_html).and_return("transformed html")
    get_preview
    assigns[:preview].should == "transformed html"
  end
  
  it "renders the textile/preview template without a layout" do
    get_preview
    response.should render_template("textile/preview")
    
    controller.expect_render(:layout => false)
    get_preview
  end
  
end
