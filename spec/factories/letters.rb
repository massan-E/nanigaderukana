FactoryBot.define do
  factory :letter do
    sequence(:radio_name) { |n| "ラジオネーム#{n}" }
    sequence(:title) { |n| "タイトル#{n}" }
    body { "手紙の本文です" }
    is_read { false }
    publish { false }
    association :user
    association :letterbox
    association :program
  end
end
