FactoryBot.define do
  factory :team_wallet do
    user { create(:user) }
    balance { 0 }
  end
end
