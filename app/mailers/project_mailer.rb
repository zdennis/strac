class ProjectMailer < ActionMailer::Base
  REPLY_ADDRESS = "strac@mutuallyhuman.com"
  def project_created_notification(project, user)
    recipients user.email_address
    subject "Successfully created project '#{project.name}' on Strac"
    body :project_path => project_path(project)
    from REPLY_ADDRESS
  end
end