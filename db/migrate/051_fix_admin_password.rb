class FixAdminPassword < ActiveRecord::Migration
  class User < ActiveRecord::Base 
    acts_as_login_model
  end
  
  def self.up
    if admin=User.find_by_email_address("admin@example.com")
      admin.update_attributes(:password => "password", :password_confirmation => "password")
    end
  end

  def self.down
  end
end
