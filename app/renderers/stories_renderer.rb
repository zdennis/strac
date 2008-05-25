class StoriesRenderer < Renderer
  def add_to_story_list story
    bucket_id = "iteration_#{story.bucket ? story.bucket.id : 'nil'}"
    @page.insert_html :bottom, bucket_id, :partial => 'list', :locals => { :stories => [ story ] }
  end
end