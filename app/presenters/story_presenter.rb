class StoryPresenter < PresentationObject
  def initialize(options)
    @story = options[:story]
  end
  
  delegate :class, :id, :new_record?, :to_param,
           :bucket_id, :comments, :description, :errors, :points, :priority_id, 
           :project, :responsible_party_type_id, :status_id, :summary, :tag_list,
           :to => :@story

  declare :possible_buckets do
    bucket_hash = @story.project.buckets.group_by(&:type)
    bucket_hash.keys.inject([]) do |arr,key| 
      values = bucket_hash[key]
      arr << OpenStruct.new(:name => values.first.type, :group => values)
    end
  end
  
  declare :possible_statuses do
    Status.find(:all).map{ |status| [status.name, status.id] }.unshift []
  end

  declare :possible_priorities do
    Priority.find(:all).map{ |priority| [priority.name, priority.id] }.unshift []
  end
end