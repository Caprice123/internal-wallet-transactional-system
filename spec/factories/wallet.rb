FactoryBot.define do
  factory :wallet do
    account { create(:user_account) }
    current_balance { 0 }
  end
end
