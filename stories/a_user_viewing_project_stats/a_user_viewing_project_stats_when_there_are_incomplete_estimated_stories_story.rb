require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Stats", %|
  As a user 
  I should be able to view project statistics
  so that I can view important information about my project quickly.|, 
  :type => RailsStory do
  extend ProjectStatsStoryHelper
  
  Scenario "a project with incomplete, estimated stories" do
    Given "there are incomplete, estimated stories added to the project" do
      destroy_stories_and_iterations
      @project = Generate.project
      @stories = generate_estimated_stories_for_project @project
    end
    When "the user views the project summary" do
      a_user_viewing_a_project :project => @project
    end
    Then "they will see the sum of total points for the project" do
      see_total_points @stories.sum(&:points)
    end
    And "they will see zero completed points for the project" do
      see_completed_points 0
    end
    And "they will see remaining points for the project" do
      see_remaining_points @stories.sum(&:points)
    end
    And "they will see zero completed iterations" do
      see_zero_completed_iterations
    end
    And "they will see zero as the average velocity for the project" do
      see_zero_average_velocity
    end
    And "they will zero estimated remaining iterations for the project" do
      see_zero_estimated_remaining_iterations
    end
    And "they will see today the estimated completion date for the project" do
      see_today_as_the_estimated_completion_date
    end
  end
end