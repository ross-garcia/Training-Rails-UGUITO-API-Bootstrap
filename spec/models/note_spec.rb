require 'rails_helper'

RSpec.describe Note, type: :model do
  subject(:note) { create(:note) }

  %i[title content note_type].each do |value|
    it { is_expected.to validate_presence_of(value) }
  end

  it { expect(subject).to define_enum_for(:note_type).with_values({ review: 0, critique: 1 }) }

  it { is_expected.to have_one(:utility).through(:user) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe '.content_length' do
    let(:north_utility) { create(:north_utility, code: 1) }
    let(:south_utility) { create(:south_utility, code: 2) }

    let(:north_user) { create(:user, utility_id: north_utility.id) }
    let(:south_user) { create(:user, utility_id: south_utility.id) }

    context 'when North Utility' do
      let(:north_note) { create(:note, user_id: north_user.id, content: content, note_type: :critique) }

      context 'with content <= 50 words' do
        let(:content) { Faker::Lorem.words(number: 50).join(' ') }

        it 'return "short"' do
          expect(north_note.content_length).to eq('short')
        end
      end

      context 'with content > 50 and content <= 100' do
        let(:content) { Faker::Lorem.words(number: 100).join(' ') }

        it 'return "medium"' do
          expect(north_note.content_length).to eq('medium')
        end
      end

      context 'with content > 100' do
        let(:content) { Faker::Lorem.words(number: 101).join(' ') }

        it 'return "long"' do
          expect(north_note.content_length).to eq('long')
        end
      end
    end

    context 'when South Utility' do
      let(:south_note) { create(:note, user_id: south_user.id, content: content, note_type: :critique) }

      context 'with content <= 60 words' do
        let(:content) { Faker::Lorem.words(number: 60).join(' ') }

        it 'return "short"' do
          expect(south_note.content_length).to eq('short')
        end
      end

      context 'with content > 60 and content <= 120' do
        let(:content) { Faker::Lorem.words(number: 120).join(' ') }

        it 'return "medium"' do
          expect(south_note.content_length).to eq('medium')
        end
      end

      context 'with content > 120' do
        let(:content) { Faker::Lorem.words(number: 121).join(' ') }

        it 'return "long"' do
          expect(south_note.content_length).to eq('long')
        end
      end
    end
  end

  describe '.validate_content_length' do
    let(:north_utility) { create(:north_utility, code: 1) }
    let(:south_utility) { create(:south_utility, code: 2) }

    let(:north_user) { create(:user, utility_id: north_utility.id) }
    let(:south_user) { create(:user, utility_id: south_utility.id) }

    context 'when North Utility' do
      let(:north_note) { build(:note, user_id: north_user.id, content: content, note_type: :review) }

      context 'with content <= 50 words and note_type is "review"' do
        let(:content) { Faker::Lorem.words(number: 50).join(' ') }

        it 'valid North Note' do
          expect(north_note).to be_valid
        end
      end

      context 'with content > 50 words and note_type is "review"' do
        let(:content) { Faker::Lorem.words(number: 51).join(' ') }

        it 'invalid North Note' do
          expect(north_note).not_to be_valid
        end
      end
    end

    context 'when South Utility' do
      let(:south_note) { build(:note, user_id: south_user.id, content: content, note_type: :review) }

      context 'with content <= 60 words and note_type is "review"' do
        let(:content) { Faker::Lorem.words(number: 60).join(' ') }

        it 'valid South Note' do
          expect(south_note).to be_valid
        end
      end

      context 'with content > 60 words and note_type is "review"' do
        let(:content) { Faker::Lorem.words(number: 61).join(' ') }

        it 'invalid South Note' do
          expect(south_note).not_to be_valid
        end
      end
    end
  end
end
