class ProjectChartPresenter < PresentationObject
  def initialize project
    @project = project
  end
  
  declare :iterations do
    @project.iterations.sort_by{ |iteration| iteration.started_at }
  end
  
  declare :completed_points do
    completed_points = iterations.map{|iteration| iteration.snapshot.completed_points}
    completed_points << @project.completed_points
    completed_points
  end
  
  declare :total_points do
    total_points = iterations.map{|iteration| iteration.snapshot.total_points}
    total_points << @project.total_points
    total_points
  end
  
  declare :remaining_points do
    remaining_points = iterations.map{|iteration| iteration.snapshot.remaining_points}
    remaining_points << @project.remaining_points
    remaining_points
  end
end