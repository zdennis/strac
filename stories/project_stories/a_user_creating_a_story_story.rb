require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "Creating Stories", %|
  As a User
  I want to be able to create stories.|, 
  :steps_for => [:a_user_creating_a_story],
  :type => RailsStory do

  Scenario "a user with access creates a story" do
    Given "there is a project with stories"
    And "a logged in user accesses the project"
    When "the user creates a story"
    Then "the user is notified of success"
    And "the story list is updated"
  end
end
