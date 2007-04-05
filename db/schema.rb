# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 22) do

  create_table "activities", :force => true do |t|
    t.column "actor_id",      :integer
    t.column "action",        :string
    t.column "affected_id",   :integer
    t.column "affected_type", :string
    t.column "created_at",    :datetime
  end

  create_table "companies", :force => true do |t|
    t.column "name", :string
  end

  create_table "groups", :force => true do |t|
    t.column "name", :string
  end

  create_table "groups_privileges", :force => true do |t|
    t.column "group_id",     :integer
    t.column "privilege_id", :integer
  end

  create_table "iterations", :force => true do |t|
    t.column "start_date", :date
    t.column "end_date",   :date
    t.column "project_id", :integer
    t.column "name",       :string
    t.column "budget",     :integer, :default => 0
  end

  create_table "priorities", :force => true do |t|
    t.column "name",     :string
    t.column "color",    :string
    t.column "position", :integer
  end

  create_table "privileges", :force => true do |t|
    t.column "name", :string
  end

  create_table "projects", :force => true do |t|
    t.column "name", :string
  end

  create_table "statuses", :force => true do |t|
    t.column "name",  :string
    t.column "color", :string
  end

  create_table "stories", :force => true do |t|
    t.column "summary",                :string
    t.column "description",            :text
    t.column "points",                 :integer
    t.column "position",               :integer
    t.column "iteration_id",           :integer
    t.column "project_id",             :integer
    t.column "responsible_party_id",   :integer
    t.column "responsible_party_type", :string
    t.column "status_id",              :integer
    t.column "priority_id",            :integer
  end

  create_table "taggings", :force => true do |t|
    t.column "tag_id",        :integer
    t.column "taggable_id",   :integer
    t.column "taggable_type", :string
  end

  create_table "tags", :force => true do |t|
    t.column "name", :string
  end

  create_table "time_entries", :force => true do |t|
    t.column "hours",         :decimal, :precision => 10, :scale => 2
    t.column "comment",       :string
    t.column "date",          :date
    t.column "project_id",    :integer
    t.column "timeable_id",   :integer
    t.column "timeable_type", :string
  end

  create_table "users", :force => true do |t|
    t.column "username",      :string
    t.column "password_hash", :string
    t.column "first_name",    :string
    t.column "last_name",     :string
    t.column "email_address", :string
    t.column "group_id",      :integer
    t.column "company_id",    :integer
  end

end
