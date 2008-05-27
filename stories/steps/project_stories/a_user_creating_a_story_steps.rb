steps_for :a_user_creating_a_story do
  Given "there is a project with stories" do
    @project = Generate.project
    @stories = Generate.stories :count => 10, :project => @project
  end
  Given "a logged in user accesses the project" do
    @user = Generate.user
    @user.projects << @project
    get login_path
    login_as @user.email_address, "password"    
  end
  
  When "the user creates a story" do
    post stories_path(@project), 
      :story => {:summary => "My Story"}
  end
  
  Then "the user is notified of success" do
    response.should have_rjs(:chained_replace_html, "notice", /My Story/)
    response.should have_rjs(:hide, "error")
    response.should have_rjs(:show, "notice")
  end
  
  Then "the story list is updated" do
    response.should have_rjs(:insert_html, :bottom, "iteration_nil", /My Story/)
    response.should have_rjs(:chained_replace_html, "iteration_nil_story_new"){
      with_tag("input[value=?]", "My Story", false)
    }
    response.body.should match(/Strac.Iteration.drawWorkspaceVelocityMarkers/)
  end
  
  Then "the positions of the stories are updated" do
    @reordered_ids.each_with_index do |id, i|
      Story.find(id).position.should == i+1
    end
  end
  
end
