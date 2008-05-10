class ProjectsController < ApplicationController
  restrict_to :user
  
  def chart
    @project=ProjectPermission.find_project_for_user(params[:id], current_user)
    total_points = []
    points_completed = []
    points_remaining = []
    
    iterations = @project.iterations.sort_by{ |iteration| iteration.start_date }
    iterations.each do |iteration|
      points_completed << iteration.snapshot.completed_points
      points_remaining << iteration.snapshot.remaining_points
      total_points << iteration.snapshot.total_points
    end
    points_completed << @project.completed_points
    points_remaining << @project.remaining_points
    total_points << @project.total_points

    step_count = 6
    min = 0
    max = (points_completed + total_points + points_remaining).max
    step = max / step_count.to_f
    ylabels = []
    min.step(max, step) { |f| ylabels << f.round }
    xlabels = iterations.map{ |e| iterations.index(e) } + ["current"]

    red = 'FF0000'
    yellow = 'FFFF00'
    green = '00FF00'
    blue = '0000FF'
    
    chart = Gchart.new(
     :data =>       [total_points, points_remaining, points_completed], 
     :bar_colors => [blue,         green,            yellow],
     :size => "600x200",
     :axis_with_labels => ["x", "y"],
     :axis_labels => [xlabels, ylabels],
     :legend => ["Total Points", "Points Remaining", "Total Points Completed"]
    )
    
    render :text => chart.send!(:fetch)
  end

  def index
    @projects = ProjectPermission.find_all_projects_for_user(current_user)
  end

  def show
    if @project=ProjectPermission.find_project_for_user(params[:id], current_user)
      @project
    else
      redirect_to "/access_denied.html"
    end
  end

  def new
    @project = Project.new
  end

  def edit
    if @project=ProjectPermission.find_project_for_user(params[:id], current_user)
      @project
    else
      redirect_to "/access_denied.html"
    end
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
end
