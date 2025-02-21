require 'rails_helper'

RSpec.describe Letter, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:radio_name) }
    it { should validate_length_of(:radio_name).is_at_most(50) }
    it { should validate_length_of(:title).is_at_most(100) }
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_most(999) }
  end

  describe 'アソシエーション' do
    it { should belong_to(:user).optional }
    it { should belong_to(:letterbox) }
    it { should belong_to(:program) }
  end

  describe '.reset_is_read' do
    let!(:read_letter) { create(:letter, is_read: true) }
    let!(:unread_letter) { create(:letter, is_read: false) }

    it '既読の手紙をすべて未読に戻すこと' do
      Letter.reset_is_read
      expect(read_letter.reload.is_read).to be false
      expect(unread_letter.reload.is_read).to be false
    end
  end
end
