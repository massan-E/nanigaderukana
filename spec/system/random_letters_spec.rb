require 'rails_helper'

RSpec.describe 'RandomLetters', type: :system do
  let(:user) { create(:user) }
  let!(:program) { create(:program, user: user) }
  let!(:letterbox) { create(:letterbox, program: program) }
  let!(:letters) { create_list(:letter, 3, letterbox: letterbox, program: program, publish: true) }

  before do
    sign_in user
  end

  describe 'ランダム表示機能', js: true do
    context '未読のお便りがある場合' do
      it 'ランダムにお便りが表示されること' do
        visit program_letters_path(program)
        click_link 'ランダム表示'

        within_window(windows.last) do
          expect(page).to have_content 'なにがでるかな！？'
          click_link 'ランダム表示'

          displayed_letter = letters.find { |letter| page.has_content?(letter.radio_name) && page.has_content?(letter.body) }
          expect(displayed_letter).to be_present
          expect(displayed_letter.reload.is_read).to be true
        end
      end

      it 'もう一度ランダム表示を押すと別のお便りが表示されること' do
        visit program_letters_path(program)
        click_link 'ランダム表示'

        within_window(windows.last) do
          expect(page).to have_content 'なにがでるかな！？'
          click_link 'ランダム表示'
          first_letter = letters.find { |letter| page.has_content?(letter.radio_name) && page.has_content?(letter.body) }
          click_link 'もう一度ランダム表示'
          # 2回目に表示されたお便りが最初のお便りと異なることを確認
          displayed_letter = letters.find { |letter| page.has_content?(letter.radio_name) && page.has_content?(letter.body) }
          expect(displayed_letter).not_to eq first_letter
        end
      end
    end

    context '全てのお便りが既読の場合' do
      before do
        letters.each { |letter| letter.update(is_read: true) }
      end

      it '中に誰もいませんよ？画面が表示されること' do
        visit program_letters_path(program)
        click_link 'ランダム表示'

        within_window(windows.last) do
          click_link 'ランダム表示'
          expect(page).to have_content '中に誰もいませんよ？'
        end
      end
    end

    describe '既読リセット機能' do
      context '全てのお便りが既読の場合' do
        before do
          letters.each { |letter| letter.update!(is_read: true) }
        end

        it '既読リセットボタンで全ての手紙が未読になること', js: true do
          visit program_letters_path(program)
          click_link 'ランダム表示'

          within_window(windows.last) do
            expect(page).to have_content 'なにがでるかな！？'
            expect(letters.all? { |letter| letter.reload.is_read? }).to be true

            click_link '既読リセット'
            # リダイレクト後のページ読み込みを待機
            expect(page).to have_content 'なにがでるかな！？'
            letters.each do |letter|
              expect(letter.reload.is_read).to be false
            end
          end
        end
      end
    end
  end
end
