# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "securepassword123" }  # Meets the 12 character minimum
    password_confirmation { "securepassword123" }
    role { :user }  # Default role

    # Create an admin user
    factory :admin do
      role { :admin }
    end

    factory :user_with_groups do
      transient do
        groups_count { 2 }
      end

      after(:create) do |user, evaluator|
        create_list(:group_membership, evaluator.groups_count, user: user)
      end
    end

    factory :user_with_created_groups do
      transient do
        created_groups_count { 2 }
      end

      after(:create) do |user, evaluator|
        create_list(:group, evaluator.created_groups_count, creator: user)
      end
    end
  end
end