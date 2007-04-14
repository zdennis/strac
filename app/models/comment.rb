# == Schema Information
# Schema version: 27
#
# Table name: comments
#
#  id             :integer(11)   not null, primary key
#  content        :text          
#  created_at     :datetime      
#  user_id        :integer(11)   
#  commenter_id   :integer(11)   
#  commenter_type :string(255)   
#

class Comment < ActiveRecord::Base
  belongs_to :commenter, :class_name => "User", :foreign_key => "commenter_id"
  belongs_to :commentable, :polymorphic => true
  
  validates_presence_of :commenter_id, :content, :commentable_id, :commentable_type
end