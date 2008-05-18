class Project
  module Base
    def incomplete_stories
      stories.find(:all, :conditions => ["status_id NOT IN(?) OR status_id IS NULL", Status.complete], :order => "position ASC")
    end

    def iterations_ordered_by_started_at
      iterations.find(:all, :order => :started_at)
    end

    def recent_activities(days=1)
      self.activities.find( 
        :all, 
        :conditions => ["created_at >= ?",  Date.today - days ],
        :order => "created_at DESC"
      )
    end

    def backlog_iteration
      iterations.build(:name => "Backlog")
    end

    def backlog_stories
      stories.find_backlog(:order => :position)
    end

    def update_members(member_ids)
      self.users.clear
      member_ids.each do |member|
        self.users << User.find(member)
      end
    end
  end
end