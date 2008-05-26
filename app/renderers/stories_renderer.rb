class StoriesRenderer < Renderer
  def add_to_story_list story
    page.insert_html :bottom, bucket_id(story), :partial => 'list', :locals => { :stories => [ story ] }
  end
  
  def make_new_story_sortable_in_project story, project
    iteration_list_ids = [ "iteration_nil" ] + project.iterations.map{ |i| "iteration_#{i.id}" }
    page.sortable bucket_id(story), :url => reorder_stories_path(project), :method => :put,
                                :tag => 'div', :handle => 'draggable', :dropOnEmpty => true, :containment => iteration_list_ids
  end
  
  def clear_new_story_form story
    blank_story = Story.new :bucket_id => story.bucket_id # we want a fresh form
    page["#{bucket_id(story)}_story_new"].replace_html :partial => 'stories/new', :locals => { :story => blank_story }    
  end
  
  private
  
  def bucket_id(story)
    "iteration_#{story.bucket ? story.bucket.id : 'nil'}"
  end
end