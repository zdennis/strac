class ProjectsController < ApplicationController
  restrict_to :user
  
  def chart
    @project=ProjectPermission.find_project_for_user(params[:id], current_user)
    @project_chart_presenter = ProjectChartPresenter.new @project
    
    trends = []
        
    iterations = @project.iterations.sort_by{ |iteration| iteration.started_at }
     
    data =   [
      @project_chart_presenter.total_points, 
      @project_chart_presenter.completed_points, 
      @project_chart_presenter.remaining_points
    ]
    colors = [
      @project_chart_presenter.total_points_color,         
      @project_chart_presenter.completed_points_color,            
      @project_chart_presenter.remaining_points_color
    ]
    
    legend = ["Total Points", "Total Points Completed", "Points Remaining"]
    
    if @project_chart_presenter.show_trends?
      data << @project_chart_presenter.trends
      colors << @project_chart_presenter.dark_remaining_points_color
      legend << "Points Remaining Trend"
    end
    
    chart = Gchart.new(
     :data =>       data, 
     :bar_colors => colors,
     :size => "600x200",
     :axis_with_labels => ["x", "y"],
     :axis_labels => [@project_chart_presenter.xlabels, @project_chart_presenter.ylabels],
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
end
