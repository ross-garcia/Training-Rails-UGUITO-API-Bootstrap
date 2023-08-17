require 'rails_helper'

RSpec.describe Utility, type: :model do
  subject(:utility) do
    build(:utility)
  end

  %i[name type].each do |value|
    it { is_expected.to validate_presence_of(value) }
  end

  it { is_expected.to have_many(:users).dependent(:destroy) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end
end
