class Story < ActiveRecord::Base
  belongs_to :author
  acts_as_textiled :body, :description => :lite_mode
  
  def name
    summary
  end
end
