class StoryPresenter < PresentationObject
  def initialize(options)
    @story = options[:story]
  end
  
  delegate :class, :id, :new_record?, :to_param,
           :bucket_id, :description, :points, :priority_id, 
           :responsible_party_type_id, :status_id, :summary, :tag_list,
           :to => :@story

  
  declare :possible_statuses do
    Status.find(:all).map{ |status| [status.name, status.id] }.unshift []
  end
  
end