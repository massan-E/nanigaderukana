require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    subject { build(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should allow_value(nil).for(:email) }
    it { should validate_uniqueness_of(:email).allow_blank.case_insensitive }
  end

  describe 'アソシエーション' do
    it { should have_many(:letters).dependent(:destroy) }
    it { should have_many(:programs).dependent(:destroy) }
    it { should have_many(:user_participations).dependent(:destroy) }
    it { should have_many(:joined_programs).through(:user_participations).source(:program) }
  end

  describe '.digest' do
    it 'BCryptパスワードハッシュを生成すること' do
      password = 'password123'
      digest = User.digest(password)
      expect(BCrypt::Password.new(digest).is_password?(password)).to be true
    end
  end

  describe '.new_token' do
    it 'ランダムなトークンを生成すること' do
      expect(User.new_token).to be_a(String)
      expect(User.new_token).not_to eq(User.new_token)
    end
  end
end
