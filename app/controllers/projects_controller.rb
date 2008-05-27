class ProjectsController < ApplicationController
  restrict_to :user
  
  def chart
    @project=ProjectPermission.find_project_for_user(params[:id], current_user)
    @project_chart_presenter = ProjectChartPresenter.new @project
    
    data = @project_chart_presenter.data
    colors = @project_chart_presenter.colors
    legend = @project_chart_presenter.legend
    
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
