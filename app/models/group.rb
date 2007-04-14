class Group < ActiveRecord::Base
  def groups
    case name
    when "Admin"
      [ "Admin", "Developer", "Customer Admin", "Customer" ]
    when "Developer"
      [ "Developer" ]
    when "Customer Admin"
      [ "Customer Admin", "Customer" ]
    when "Customer"
      [ "Customer" ]
    end
  end
end

load File.join( RAILS_ROOT, 'vendor/plugins/lwt_authentication_system/lib/group_model.rb' )