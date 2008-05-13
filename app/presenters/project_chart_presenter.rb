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
  
  declare :show_trends? do
    iterations.size > 1
  end
  
  declare :trends do
    iteration_count = iterations.size
    show_trends = iteration_count > 1
    if show_trends
      xvalues = (1..iteration_count).to_a
      yvalues = remaining_points.values_at(*xvalues)
      _slope = slope(xvalues, yvalues)
      _intercept = intercept(_slope, xvalues, yvalues)
      trends = (0..iteration_count).inject([]) {|values, i| values << _intercept + i*_slope }
    end
  end
  
  declare :ylabels do
    step_count = 6
    min = 0
    max = (completed_points + total_points + remaining_points).map(&:to_i).max
    step = [max / step_count.to_f, 1].max
    ylabels = []
    min.step(max, step) { |f| ylabels << f.round }
    ylabels
  end
  
  private
  
  def sum(arr)
    arr.inject(0.0){ |sum, x|
      sum + x
    }
  end
  
  def sum_products(xs, ys)
    xs.zip(ys).inject(0.0){|result, (x,y)|
      result + x*y
    }
  end
  
  def sum_squares(xs)
    xs.inject(0.0) {|result, x|
      result + x*x
    }
  end
  
  def slope(xs, ys)
    n = xs.size
    (n*sum_products(xs, ys) - sum(xs)*sum(ys)) / (n*sum_squares(xs) - sum(xs)**2)
  end
  
  def intercept(m, xs,ys)
    (sum(ys) - m*sum(xs))/xs.size
  end
end