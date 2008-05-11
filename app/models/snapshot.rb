# == Schema Information
# Schema version: 50
#
# Table name: snapshots
#
#  id                             :integer(11)   not null, primary key
#  total_points                   :integer(11)   
#  completed_points               :integer(11)   
#  remaining_points               :integer(11)   
#  average_velocity               :float         
#  estimated_remaining_iterations :float         
#  estimated_completion_date      :date          
#  bucket_id                      :integer(11)   
#  created_at                     :datetime      
#  updated_at                     :datetime      
#

class Snapshot < ActiveRecord::Base
  belongs_to :bucket
end
