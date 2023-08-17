require 'rails_helper'

RSpec.describe Book, type: :model do
  subject(:book) do
    create(:book)
  end

  %i[utility_id user_id genre title publisher year].each do |value|
    it { is_expected.to validate_presence_of(value) }
  end

  it 'has a valid factory' do
    expect(subject).to be_valid
  end
end
