# == Schema Information
# Schema version: 50
#
# Table name: buckets
#
#  id          :integer(11)   not null, primary key
#  started_at  :datetime      
#  ended_at    :datetime      
#  project_id  :integer(11)   
#  name        :string(255)   
#  budget      :integer(11)   default(0)
#  created_at  :datetime      
#  updated_at  :datetime      
#  type        :string(255)   
#  description :text          
#

class Bucket < ActiveRecord::Base
  belongs_to :project
  has_one :snapshot, :dependent => :destroy  
  has_many :stories, :order => :position, :dependent => :nullify

  validates_presence_of :project_id, :name

  def completed_stories
    stories.find(:all, :conditions => ['status_id=?', Status.complete.id], :order => "position ASC")
  end

  def display_name
    name
  end
end
