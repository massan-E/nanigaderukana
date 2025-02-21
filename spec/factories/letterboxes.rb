FactoryBot.define do
  factory :letterbox do
    sequence(:title) { |n| "レターボックス#{n}" }
    body { "レターボックスの説明文です" }
    publish { false }
    association :program
  end
end
