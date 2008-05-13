class ProjectChartPresenter < PresentationObject
  def initialize project
    @project = project
  end
  
  declare :points_completed do
    iterations = @project.iterations.sort_by{ |iteration| iteration.started_at }
    points_completed = iterations.map{|iteration| iteration.snapshot.completed_points}
    points_completed << @project.completed_points
    points_completed
  end
end