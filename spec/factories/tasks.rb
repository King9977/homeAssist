
FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Task #{n}" }
    description { "This is a test task" }
    due_date { 1.week.from_now }
    status { "offen" }
    
    association :group
    association :user
    
    # If you have an association for assigned_user
    association :assigned_user, factory: :user
  end
end