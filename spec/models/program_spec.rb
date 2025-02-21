require 'rails_helper'

RSpec.describe Program, type: :model do
  describe 'バリデーション' do
    subject { build(:program) }

    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title).case_insensitive }
    it { should validate_length_of(:title).is_at_most(100) }
    it { should validate_length_of(:body).is_at_most(255).allow_nil }

    it do
      should validate_content_type_of(:image).
        allowing('image/jpeg', 'image/png', 'image/gif', 'image/webp')
    end

    it do
      should validate_size_of(:image).
        less_than_or_equal_to(5.megabytes)
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should have_many(:user_participations).dependent(:destroy) }
    it { should have_many(:participants).through(:user_participations).source(:user) }
    it { should have_many(:letterboxes).dependent(:destroy) }
    it { should have_many(:letters).dependent(:nullify) }
  end

  describe '#invitation_expired?' do
    let(:program) { create(:program) }

    context '招待期限が3日以上経過している場合' do
      before do
        program.update(send_invitation_at: 4.days.ago)
      end

      it 'trueを返すこと' do
        expect(program.invitation_expired?).to be true
      end
    end

    context '招待期限が3日以内の場合' do
      before do
        program.update(send_invitation_at: 2.days.ago)
      end

      it 'falseを返すこと' do
        expect(program.invitation_expired?).to be false
      end
    end
  end
end
