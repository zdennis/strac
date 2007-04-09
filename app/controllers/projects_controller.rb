class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml
  def index
    @projects = ProjectPermission.find_all_projects_for_user( current_user )
    
    respond_to do |format|
      format.html { render :action => "index.erb" }
      format.xml { render :xml => @projects.to_xml }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = ProjectPermission.find_project_for_user( params[:id], current_user )
    
    respond_to do |format|
      format.html { render :action => "show.erb" }
      format.xml { render :xml => @project.to_xml }
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1;edit
  def edit
    @project = ProjectPermission.find_project_for_user( params[:id], current_user )
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save 
        current_user.projects << @project
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to project_url(@project) }
        format.xml { head :created, :location => project_url(@project) }
      else
        format.html { render :action => "new.erb" }
        format.xml { render :xml => @project.errors.to_xml }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = ProjectPermission.find_project_for_user( params[:id], current_user )

    respond_to do |format|
      if @project.update_attributes(params[:project])
        @project.users.clear
        @project.companies.clear
        User.find( params[:users] ).each { |u| @project.users << u } unless params[:users].blank?
        Company.find( params[:companies] ).each { |c| @project.companies << c } unless params[:companies].blank?
        
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to project_url(@project) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit.erb" }
        format.xml { render :xml => @project.errors.to_xml }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = ProjectPermission.find_project_for_user( params[:id], current_user )
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.xml { head :ok }
    end
  end
end
