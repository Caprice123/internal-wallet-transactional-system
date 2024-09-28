FactoryBot.define do
  factory :wallet do
    account { create(:user_account) }
    balance { 0 }
  end
end
