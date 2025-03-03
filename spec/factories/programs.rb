FactoryBot.define do
  factory :program do
    sequence(:title) { |n| "プログラム#{n}" }
    body { "プログラムの説明文です" }
    association :user

    after(:create) do |program|
      create(:user_participation, user: program.user, program: program)
    end
  end
end
