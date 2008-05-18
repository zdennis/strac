# == Schema Information
# Schema version: 50
#
# Table name: projects
#
#  id               :integer(11)   not null, primary key
#  name             :string(255)   
#  created_at       :datetime      
#  updated_at       :datetime      
#  iteration_length :string(255)   
#

class Project < ActiveRecord::Base
  
  include Project::Base
  include Project::Statistics
  
  validates_presence_of :name
  
  has_many :invitations
  has_many :time_entries
  has_many :stories do
    include Project::StorySearch
  end
  has_many :activities
  has_many :project_permissions, :dependent => :destroy
  has_many_polymorphs :accessors, :through => :project_permissions, :from => [:users]
  has_many :buckets
  has_many :phases 
  has_many :iterations do 
    include Project::IterationShortcuts
  end
  has_many :completed_iterations, :source => :iterations, :class_name => Iteration.name, :conditions => [ "ended_at < ?", Date.today ]
  has_many :story_tags, :class_name => Tag.name, :finder_sql => '
    SELECT tags.*
    FROM projects
    INNER JOIN stories ON stories.project_id=projects.id
    INNER JOIN taggings ON (taggings.taggable_id=stories.id AND taggings.taggable_type=\'Story\')
    INNER JOIN tags ON tags.id=taggings.tag_id
    WHERE
      projects.id = #{id}
    GROUP BY tags.id'
  has_many :tagless_stories, :class_name => Story.name, :finder_sql => '
    SELECT stories.*
    FROM projects
    INNER JOIN stories ON stories.project_id=projects.id
    LEFT JOIN taggings ON (taggings.taggable_id=stories.id AND taggings.taggable_type=\'Story\')
    WHERE
      projects.id = #{id} AND
      taggings.taggable_id IS NULL'
end
