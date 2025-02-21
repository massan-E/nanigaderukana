FactoryBot.define do
  factory :program do
    sequence(:title) { |n| "プログラム#{n}" }
    body { "プログラムの説明文です" }
    association :user
    send_invitation_at { Time.current }
  end
end
