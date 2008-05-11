class ProjectsController < ApplicationController
  restrict_to :user
  
  def chart
    @project=ProjectPermission.find_project_for_user(params[:id], current_user)
    total_points = []
    points_completed = []
    points_remaining = []
    trends = []
    
    iterations = @project.iterations.sort_by{ |iteration| iteration.started_at }
    iterations.each do |iteration|
      points_completed << iteration.snapshot.completed_points
      points_remaining << iteration.snapshot.remaining_points
      total_points << iteration.snapshot.total_points
    end
    points_completed << @project.completed_points
    points_remaining << @project.remaining_points
    total_points << @project.total_points
    
    iteration_count = iterations.size
    xvalues = (0..iteration_count).to_a
    _slope = slope(xvalues, points_remaining)
    _intercept = intercept(_slope, xvalues, points_remaining)
    trends = xvalues.inject([]) {|values, i| values << _intercept + i*_slope }
     
    step_count = 6
    min = 0
    max = (points_completed + total_points + points_remaining).map(&:to_i).max
    step = max / step_count.to_f
    ylabels = []
    min.step(max, step) { |f| ylabels << f.round }
    xlabels = iterations.map{ |e| iterations.index(e) } + ["current"]

    red = 'FF0000'
    dark_purple = '551a8b'
    green = '00FF00'
    blue = '0000FF'
    purple = 'a020f0'
    
    chart = Gchart.new(
     :data =>       [total_points, points_completed, points_remaining, trends], 
     :bar_colors => [blue,         green,            purple, dark_purple],
     :size => "600x200",
     :axis_with_labels => ["x", "y"],
     :axis_labels => [xlabels, ylabels],
     :legend => ["Total Points", "Points Remaining", "Total Points Completed", "Points Remaining Trend"]
    )
    
    render :text => chart.send!(:fetch)
  end

  def index
    @projects = ProjectPermission.find_all_projects_for_user(current_user)
  end

  def show
    @project = ProjectPermission.find_project_for_user(params[:id], current_user)
    redirect_to "/access_denied.html" unless @project
  end

  def new
    @project = Project.new
  end

  def edit
    @project = ProjectPermission.find_project_for_user(params[:id], current_user)
    redirect_to "/access_denied.html" unless @project
  end

  def create
    @project = Project.new(params[:project])
    
    if @project.save 
      current_user.projects << @project
      flash[:notice] = 'Project was successfully created.'
      redirect_to project_path(@project)
    else
      render :action => "new"
    end
  end

  def update
    @project = ProjectPermission.find_project_for_user(params[:id], current_user)
    if @project && @project.update_attributes(params[:project])
      @project.update_members params[:users]
      flash[:notice] = 'Project was successfully updated.'
      redirect_to project_path(@project)
    else
      render :action => "edit"
    end
  end

  def destroy
    if @project=ProjectPermission.find_project_for_user(params[:id], current_user)
      @project
    else
      redirect_to "/access_denied.html"
    end
    @project.destroy
    redirect_to projects_path
  end
  
  def workspace
    if @project=ProjectPermission.find_project_for_user(params[:id], current_user)
      @stories = @project.incomplete_stories
    else
      redirect_to "/access_denied.html"
    end
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
