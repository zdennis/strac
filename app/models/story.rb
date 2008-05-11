# == Schema Information
# Schema version: 50
#
# Table name: stories
#
#  id                     :integer(11)   not null, primary key
#  summary                :string(255)   
#  description            :text          
#  points                 :integer(11)   
#  position               :integer(11)   
#  bucket_id              :integer(11)   
#  project_id             :integer(11)   
#  responsible_party_id   :integer(11)   
#  responsible_party_type :string(255)   
#  status_id              :integer(11)   
#  priority_id            :integer(11)   
#  created_at             :datetime      
#  completed_at           :datetime      
#  updated_at             :datetime      
#

class Story < ActiveRecord::Base
  belongs_to :bucket
  belongs_to :project
  belongs_to :status
  belongs_to :priority
  belongs_to :responsible_party, :polymorphic => true
  has_many :time_entries, :as => :timeable
  has_many :comments, :as => :commentable
  has_many :activities, :as => :affected 

  acts_as_list :scope => :bucket_id
  acts_as_taggable
  acts_as_textiled :description
  acts_as_comparable

  validates_presence_of :summary, :project_id
  validates_numericality_of :points, :position, :allow_nil => true

  before_save do |story|
    if story.status == Status.complete && story.bucket_id.nil?
      story.bucket = story.project.iterations.current
    end
  end

  def name
    summary
  end

  def responsible_party_type_id
    responsible_party ? "#{responsible_party.class.name.downcase}_#{responsible_party.id}" : ""
  end

  def responsible_party_type_id=( type_id )
    type, id = type_id.scan( /^(\w+)_(\d+)$/ ).flatten
    self.responsible_party_id = id
    self.responsible_party_type = type ? type.camelize : nil
  end

  def complete?
    status && (status.name =~ /complete/ || status.name =~ /rejected/)
  end
  
  def incomplete?
    !complete?
  end
  
  def self.find_backlog options = {}
    with_scope :find => options do
      find :all, :conditions => "bucket_id IS NULL"
    end
  end
end
