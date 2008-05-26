class StoriesRenderer < Renderer
  def add_to_story_list story
    page.insert_html :bottom, bucket_element_id(story.bucket_id), :partial => 'list', :locals => { :stories => [ story ] }
  end
  
  def make_new_story_sortable_in_project story, project
    iteration_list_ids = [ "iteration_nil" ] + project.iterations.map{ |i| "iteration_#{i.id}" }
    page.sortable bucket_element_id(story.bucket_id), :url => reorder_stories_path(project), :method => :put,
                                :tag => 'div', :handle => 'draggable', :dropOnEmpty => true, :containment => iteration_list_ids
  end
  
  def clear_new_story_form bucket_id
    blank_story = Story.new :bucket_id => bucket_id # we want a fresh form
    story_form_id = "#{bucket_element_id(bucket_id)}_story_new"
    page[story_form_id].replace_html :partial => 'stories/new', :locals => { :story => blank_story }    
  end
  
  private
  
  def bucket_element_id(bucket_id)
    "iteration_#{bucket_id ? bucket_id : 'nil'}"
  end
end