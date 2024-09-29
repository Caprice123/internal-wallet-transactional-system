FactoryBot.define do
  factory :team_wallet do
    account { create(:account) }
    balance { 0 }
  end
end
