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
    let(:note) { create(:note, user: user, content: content, note_type: :critique) }
    let(:user) { create(:user, utility: utility) }
    let(:content_length_short) { user.utility.content_length_short }
    let(:content_length_medium) { user.utility.content_length_medium }

    context 'when North Utility' do
      let(:utility) { create(:north_utility) }

      context 'with content <= content_length_short words' do
        let(:content) { Faker::Lorem.words(number: content_length_short).join(' ') }

        it 'return "short"' do
          expect(note.content_length).to eq('short')
        end
      end

      context 'with content > content_length_short and content <= content_length_medium' do
        let(:content) { Faker::Lorem.words(number: content_length_medium).join(' ') }

        it 'return "medium"' do
          expect(note.content_length).to eq('medium')
        end
      end

      context 'with content > content_length_medium' do
        let(:content) { Faker::Lorem.words(number: content_length_medium + 1).join(' ') }

        it 'return "long"' do
          expect(note.content_length).to eq('long')
        end
      end
    end

    context 'when South Utility' do
      let(:utility) { create(:south_utility) }

      context 'with content <= content_length_short words' do
        let(:content) { Faker::Lorem.words(number: content_length_short).join(' ') }

        it 'return "short"' do
          expect(note.content_length).to eq('short')
        end
      end

      context 'with content > content_length_short and content <= content_length_medium' do
        let(:content) { Faker::Lorem.words(number: content_length_medium).join(' ') }

        it 'return "medium"' do
          expect(note.content_length).to eq('medium')
        end
      end

      context 'with content > content_length_medium' do
        let(:content) { Faker::Lorem.words(number: content_length_medium + 1).join(' ') }

        it 'return "long"' do
          expect(note.content_length).to eq('long')
        end
      end
    end
  end

  describe '.validate_content_length' do
    let(:note) { build(:note, user: user, content: content, note_type: note_type) }
    let(:user) { create(:user, utility: utility) }
    let(:content_length_short) { user.utility.content_length_short }

    context 'when North Utility' do
      let(:utility) { create(:north_utility) }
      let(:note_type) { :review }

      context 'with content <= content_length_short words and note_type is "review"' do
        let(:content) { Faker::Lorem.words(number: content_length_short).join(' ') }

        it 'valid North Note' do
          expect(note).to be_valid
        end
      end

      context 'with content > content_length_short words and note_type is "review"' do
        let(:content) { Faker::Lorem.words(number: content_length_short + 1).join(' ') }

        it 'invalid North Note' do
          expect(note).not_to be_valid
        end
      end

      context 'with content > content_length_short words and note_type not is "review"' do
        let(:note_type) { :critique }
        let(:content) { Faker::Lorem.words(number: content_length_short + 1).join(' ') }

        it 'valid North Note' do
          expect(note).to be_valid
        end
      end
    end

    context 'when South Utility' do
      let(:utility) { create(:south_utility) }
      let(:note_type) { :review }

      context 'with content <= content_length_short words and note_type is "review"' do
        let(:content) { Faker::Lorem.words(number: content_length_short).join(' ') }

        it 'valid South Note' do
          expect(note).to be_valid
        end
      end

      context 'with content > content_length_short words and note_type is "review"' do
        let(:content) { Faker::Lorem.words(number: content_length_short + 1).join(' ') }

        it 'invalid South Note' do
          expect(note).not_to be_valid
        end
      end

      context 'with content > content_length_short words and note_type not is "review"' do
        let(:note_type) { :critique }
        let(:content) { Faker::Lorem.words(number: content_length_short + 1).join(' ') }

        it 'valid South Note' do
          expect(note).to be_valid
        end
      end
    end
  end
end
