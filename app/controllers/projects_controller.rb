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
    show_trends = iteration_count > 1
    if show_trends
      xvalues = (1..iteration_count).to_a
      yvalues = points_remaining.values_at(*xvalues)
      _slope = slope(xvalues, yvalues)
      _intercept = intercept(_slope, xvalues, yvalues)
      trends = (0..iteration_count).inject([]) {|values, i| values << _intercept + i*_slope }
    end
     
    step_count = 6
    min = 0
    max = (points_completed + total_points + points_remaining).map(&:to_i).max
    step = [max / step_count.to_f, 1].max
    ylabels = []
    min.step(max, step) { |f| ylabels << f.round }
    xlabels = iterations.map{ |e| iterations.index(e) } + ["current"]

    red = 'FF0000'
    dark_purple = '551a8b'
    green = '00FF00'
    blue = '0000FF'
    purple = 'a020f0'
    
    data =   [total_points, points_completed, points_remaining]
    colors = [blue,         green,            purple]
    legend = ["Total Points", "Total Points Completed", "Points Remaining"]
    
    if show_trends
      data << trends
      colors << dark_purple
      legend << "Points Remaining Trend"
    end
    
    chart = Gchart.new(
     :data =>       data, 
     :bar_colors => colors,
     :size => "600x200",
     :axis_with_labels => ["x", "y"],
     :axis_labels => [xlabels, ylabels],
     :legend => legend
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
      @project.destroy
      redirect_to projects_path
    else
      redirect_to "/access_denied.html"
    end
  end
  
  def workspace
    if @project=ProjectPermission.find_project_for_user(params[:id], current_user)
      @stories = @project.stories.find(
        :all, 
        :conditions => ["status_id NOT IN(?) OR status_id IS NULL", Status.complete], :order => "position ASC"
      )
    else
      redirect_to "/access_denied.html"
    end
  end
  
  private
  
  def sum(arr) arr.inject(0.0){|sum, x| sum + x} end
  def slope(xs, ys); n = xs.size; (n*sum(xs.zip(ys).map{|x,y| x*y}) - sum(xs)*sum(ys))/(n*sum(xs.map{|x| x*x}) - sum(xs)**2) end
  def intercept(m, xs,ys) (sum(ys) - m*sum(xs))/xs.size; end
    

end
