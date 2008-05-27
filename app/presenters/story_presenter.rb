class StoryPresenter
  
  def initialize(options)
    @story = options[:story]
  end
  
  delegate :id, :class, :errors, :to_param,
           :bucket, :bucket_id, :description, :points,
           :priority_id, :project, :responsible_party,
           :responsible_party_type_id, :status, :status_id,
           :summary, :tag_list, 
           :to => :@story
  
  def possible_priorities
    Priority.find(:all).map{ |e| [e.name, e.id] }.unshift []
  end
  
  def possible_statuses
    Status.find(:all).map{ |s| [s.name, s.id] }.unshift []
  end
  
end