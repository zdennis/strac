require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/_user_sidebar.html.erb" do
  def render_it
    render :partial => "projects/user_sidebar", :locals => { :user => @user }
  end

  before do
    @projects = [
      mock_model(Project, :name => "Project Foo"),
      mock_model(Project, :name => "Project Bar")
    ]
    @user = mock_model(User, :projects => @projects)
  end
  
  it "displays the name and a link to each of the user's project" do
    render_it
    @projects.each do |project|
      response.should have_tag('a[href=?]', project_path(project), project.name.to_regexp)
    end
  end
end