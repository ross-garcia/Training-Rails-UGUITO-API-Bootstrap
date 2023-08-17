require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  subject(:user) { build(:user) }

  %i[email password].each do |value|
    it { is_expected.to validate_presence_of(value) }
  end

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it { is_expected.to validate_confirmation_of(:password) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end
end
