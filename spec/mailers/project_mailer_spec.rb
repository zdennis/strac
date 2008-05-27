require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectMailer, "#project_created_notification" do
  include ActionController::UrlWriter

  def project_created_notification
    @email = ProjectMailer.create_project_created_notification(@project, @user)
  end
  
  before do
    @project = Generate.project :name => "Foo&Baz"
    @user = Generate.user :email_address => "bob@jones.com"
  end
  
  it "sends an email to the passed in user" do
    project_created_notification
    @email.to.should include(@user.email_address)
  end
  
  it "sends the email from strac" do
    project_created_notification
    @email.from.should include("strac@mutuallyhuman.com")
  end

  it "contains the name of the project in the email subject" do
    project_created_notification
    @email.subject.should =~ @project.name.to_regexp
  end

  describe "the email body" do
    it "includes a link to the project" do
      project_created_notification
      @email.body.should =~ project_path(@project).to_regexp
    end
  end

end