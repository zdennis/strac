class RemoteProjectRenderer < RemoteSiteRenderer
  constructor :page, :project
  
  def draw_current_iteration_velocity_marker
    @page.call "Strac.Iteration.drawWorkspaceVelocityMarkers"
  end
  
  def update_project_summary
    @page[:project_summary].replace :partial => "projects/summary", :locals => { :project => @project }  
  end
  
  def update_story_points(story)
    @page["story_#{story.id}_points"].replace_html(story.points || "&infin;")
  end
end