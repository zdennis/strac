require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "User Signup", %|
  As a User
  I want to be able to sign up
  So that I may be able to enjoy agile project management in strac!
|, :type => RailsStory do
  
  Scenario "Sending invitations" do
    Given "a user at the login page" do 
      a_user_at_the_login_page
    end
    When "they click on the signup link" do
      click_on_the_signup_link
    end
    Then "they will see the signup form" do
      see_the_signup_form
    end
    
    Given "a user viewing the signup form" do
      # already here
    end
    When "they submit the form with acceptable data" do
      submit_signup_form
    end
    Then "they will be logged in" do
      verify_the_user_has_logged_in
    end
    And "they will see the dashboard page" do
      #we've already satisfied this
    end
  end

  def a_user_at_the_login_page
    get login_path
  end
  
  def click_on_the_signup_link
    click_link signup_path
  end
  
  def see_the_signup_form
    assert_select "form[action=?]", signup_path, true
  end
  
  def verify_the_user_has_logged_in
    assert_select ".your_projects", /your projects/i, true
  end
  
  def submit_signup_form
    submit_form "signup" do |form|
      form.user.email_address = "chrisrittersdorf@gmail.com"
      form.user.password = "secret"
      form.user.password_confirmation = "secret"
    end
    follow_redirect!
  end
  
  

end