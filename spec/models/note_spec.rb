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
    let(:note) { build(:note, user: user, content: content, note_type: :critique) }
    let(:user) { create(:user, utility: utility) }

    context 'when North Utility' do
      let(:utility) { create(:north_utility) }

      context 'with content <= 50 words' do
        let(:content) { Faker::Lorem.words(number: 50).join(' ') }

        it 'return "short"' do
          expect(note.content_length).to eq('short')
        end
      end

      context 'with content > 50 and content <= 100' do
        let(:content) { Faker::Lorem.words(number: 100).join(' ') }

        it 'return "medium"' do
          expect(note.content_length).to eq('medium')
        end
      end

      context 'with content > 100' do
        let(:content) { Faker::Lorem.words(number: 101).join(' ') }

        it 'return "long"' do
          expect(note.content_length).to eq('long')
        end
      end
    end

    context 'when South Utility' do
      let(:utility) { create(:south_utility) }

      context 'with content <= 60 words' do
        let(:content) { Faker::Lorem.words(number: 60).join(' ') }

        it 'return "short"' do
          expect(note.content_length).to eq('short')
        end
      end

      context 'with content > 60 and content <= 120' do
        let(:content) { Faker::Lorem.words(number: 120).join(' ') }

        it 'return "medium"' do
          expect(note.content_length).to eq('medium')
        end
      end

      context 'with content > 120' do
        let(:content) { Faker::Lorem.words(number: 121).join(' ') }

        it 'return "long"' do
          expect(note.content_length).to eq('long')
        end
      end
    end
  end

  describe '.validate_content_length' do
    let(:note) { build(:note, user: user, content: content, note_type: note_type) }
    let(:user) { create(:user, utility: utility) }

    context 'when North Utility' do
      let(:utility) { create(:north_utility) }
      let(:note_type) { :review }

      context 'with content <= 50 words and note_type is "review"' do
        let(:content) { Faker::Lorem.words(number: 50).join(' ') }

        it 'valid North Note' do
          expect(note).to be_valid
        end
      end

      context 'with content > 50 words and note_type is "review"' do
        let(:content) { Faker::Lorem.words(number: 51).join(' ') }

        it 'invalid North Note' do
          expect(note).not_to be_valid
        end
      end

      context 'with content > 50 words and note_type not is "review"' do
        let(:note_type) { :critique }
        let(:content) { Faker::Lorem.words(number: 51).join(' ') }

        it 'valid North Note' do
          expect(note).to be_valid
        end
      end
    end

    context 'when South Utility' do
      let(:utility) { create(:south_utility) }
      let(:note_type) { :review }

      context 'with content <= 60 words and note_type is "review"' do
        let(:content) { Faker::Lorem.words(number: 60).join(' ') }

        it 'valid South Note' do
          expect(note).to be_valid
        end
      end

      context 'with content > 60 words and note_type is "review"' do
        let(:content) { Faker::Lorem.words(number: 61).join(' ') }

        it 'invalid South Note' do
          expect(note).not_to be_valid
        end
      end

      context 'with content > 60 words and note_type not is "review"' do
        let(:note_type) { :critique }
        let(:content) { Faker::Lorem.words(number: 61).join(' ') }

        it 'valid South Note' do
          expect(note).to be_valid
        end
      end
    end
  end
end
