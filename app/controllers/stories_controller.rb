class StoriesController < ApplicationController
  include ERB::Util
  
  in_place_edit_for :story, :points
  
  before_filter :find_project
  before_filter :find_priorities_and_statuses, :only => [ :new, :edit ]

  helper :comments

  def index
    @stories_presenter = StoriesIndexPresenter.new(:project => @project, :view => params['view'], :search => params[:story])
  end

  def show
    @story = @project.stories.find(params[:id], :include => [:tags, :comments] )
    @comments = @story.comments
    should_render_comment_links = false

    respond_to :html, :js
  end

  def new
    @story = @project.stories.build :bucket_id => params[:bucket_id]
    respond_to :js
  end
  
  def edit
    @story = @project.stories.find(params[:id], :include => :tags)
    respond_to do |format|
      format.html
      format.js { render :action => 'edit' }
    end
  end

  def create
    @story = @project.stories.build(params[:story])

    respond_to do |format|
      if @story.save
        format.js do
          find_priorities_and_statuses
        end
      else
        format.js do
          find_priorities_and_statuses
          render :action => "new"
        end
      end
    end
  end

  def update
    @story = @project.stories.find(params[:id], :include => :tags)

    respond_to do |format|
      if @story.update_attributes(params[:story])
        #TODO: If this stories iteration is changed, then it should move
        format.html do 
          flash[:notice] = %("#{h(@story.summary)}" was successfully updated.)
          redirect_to story_path(@project, @story)
        end
        format.js { render :template => "stories/update.js.rjs" }
      else
        format.html do
          render :action => 'edit'
        end
        format.js do
          find_priorities_and_statuses
          render :template => "stories/edit.js.rjs"
        end
      end
    end
  end

  def destroy
    @story = @project.stories.find(params[:id], :include => :tags)
    @story.destroy
  
    respond_to do |format|
      format.js
      format.html do
        flash[:notice] = %("#{@story.summary}" was successfully destroyed.)
        redirect_to stories_url(@project)
      end
    end
  end

  def reorder
    story_ids = params["iteration_nil"].delete_if{ |id| id.blank? }
    values = []
    story_ids.each_with_index { |id,i| values << [id, i+1] }
    columns2import = [:id, :position]
    columns2update = [:position]
    Story.import(columns2import, values, :on_duplicate_key_update => columns2update, :validate=>false )
    render_notice "Priorities have been successfully updated."
  rescue
    render_error "There was an error while updating priorities. If the problem persists, please contact technical support."
  end
  
  def take
    @story = @project.stories.find(params[:id])
    @story.responsible_party = User.current_user
    
    if @story.save
      render_notice %("#{@story.summary}" was successfully taken.) do |page|
        page["story_#{@story.id}_header"].replace_html :partial => "stories/release", :locals => { :story => @story }
      end
    else
      render_error %("#{@story.summary}" was not successfully taken.)
    end
  end

  def release
    @story = @project.stories.find(params[:id])
    @story.responsible_party = nil
    
    if @story.save
      render_notice %("#{@story.summary}" was successfully released.) do |page|
        page["story_#{@story.id}_header"].replace_html :partial => "stories/take", :locals => { :story => @story }
      end
    else
      render_error %("#{@story.summary}" was not successfully released.)
    end
  end
  
  def update_points
    if story=@project.stories.find(params[:id])
      if story.update_attribute(:points, params[:story][:points]) 
        render_notice %|"#{story.summary}" was successfully updated.| do |page|
          page.replace_html "story_#{story.id}_points", (story.points || "&infin;")
          page.replace :project_summary, :partial => "projects/summary", :locals => { :project => @project }  
          page.call "Strac.Iteration.drawWorkspaceVelocityMarkers"
        end
      else
        render_error %|"#{story.summary}" was not updated.|
      end
    end
  end
  
  def update_status
    @story = @project.stories.find(params[:id])
    old_status_id = @story.status_id
    @story.status_id = params[:story][:status_id]

    if @story.save
      render_notice %("#{@story.summary}" was successfully updated.) do |page|
        page["story_#{@story.id}_status_#{@story.status_id}"].addClassName("selected")
        page["story_#{@story.id}_status_#{old_status_id}"].removeClassName("selected") if old_status_id and old_status_id != @story.status_id
      end
    else
      render_error %("#{@story.summary}" was not successfully updated.)
    end
  end
  
  def time
    @story = @project.stories.find(params[:id])
    @time_entry = @project.time_entries.build(params[:time_entry])
    
    if request.post?
      @time_entry.timeable = @story
      if @time_entry.save
        #render_notice %(Time entry was successfully created.) do |page|
        #  page["story_#{@story.id}_time_list"].replace_html(@story.points || "&infin;")
        #end
      end
    else
      respond_to :js
    end
  end

private

  def find_priorities_and_statuses
    @statuses = Status.find(:all).map{ |s| [s.name, s.id] }.unshift []
    @priorities = Priority.find(:all).map{ |e| [e.name, e.id] }.unshift []
  end

  def find_project
    unless @project=ProjectPermission.find_project_for_user(params[:project_id], current_user)
      redirect_to "/access_denied.html"
      false
    end
  end
end
