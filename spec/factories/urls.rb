FactoryBot.define do
  factory :url do
    short_url { "aaaabbbb" }
    original_url  { "www.test.ru" }
    counter { 0 }
  end
end