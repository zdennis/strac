require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before(:each) do
    User.destroy_all
    @user = Generate.user :email_address => "joe@example.com"
  end
  
  describe "validations" do
    it_validates_uniqueness_of :email_address, :value => "joe@example.com"

    it "should be valid" do
      @user.group_id = 1
      @user.email_address = "me@me.com"
      @user.should be_valid
    end
  
    it "requires a group id" do
      @user.group_id = nil
      @user.should validate_presence_of(:group_id)
    end

    it "requires an email address" do
      @user.email_address = nil
      @user.should validate_presence_of(:email_address)
    end
  end
  
  describe "associations" do
    it_belongs_to :group
    it_has_many :stories, :as => :responsible_party
    it_has_many :projects, :through => :project_permissions, :source=>:project,
                :conditions => nil, :extend=>[], :class_name=>"Project", :limit=>nil,
                :order=>nil, :group=>nil, :offset=>nil, :foreign_key=>"project_id"
    it_has_many :project_permissions, :as => :accessor, :extend=>[], :dependent=>:destroy, 
                :order=>nil, :class_name=>"ProjectPermission", :conditions=>nil
  end

end
