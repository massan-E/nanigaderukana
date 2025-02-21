require 'rails_helper'

RSpec.describe Letterbox, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(100) }
    it { should validate_length_of(:body).is_at_most(255).allow_nil }
  end

  describe 'アソシエーション' do
    it { should belong_to(:program) }
    it { should have_many(:letters).dependent(:nullify) }
  end

  describe 'スコープ' do
    describe '.published' do
      let!(:published_letterbox) { create(:letterbox, publish: true) }
      let!(:unpublished_letterbox) { create(:letterbox, publish: false) }

      it '公開済みのレターボックスのみを返すこと' do
        expect(Letterbox.published).to include(published_letterbox)
        expect(Letterbox.published).not_to include(unpublished_letterbox)
      end
    end
  end
end
