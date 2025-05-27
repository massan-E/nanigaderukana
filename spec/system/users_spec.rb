require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ユーザー登録' do
    context '正常な入力の場合' do
      it 'ユーザーを新規登録できること', js: true do
        visit new_user_registration_path
        fill_in 'ユーザー名', with: 'test_user'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'

        expect {
          click_button '登録する'
          expect(page).to have_content 'Welcome to Music Hour!!'
        }.to change(User, :count).by(1)
      end
    end

    context '不正な入力の場合' do
      it 'エラーメッセージが表示されること', js: true do
        visit new_user_registration_path
        
        # フォームが表示されるのを待つ
        expect(page).to have_selector('form')
        
        # 何も入力せずに登録ボタンをクリック
        click_button '登録する'

        # エラーメッセージが表示されるまで待機
        using_wait_time(5) do
          expect(page).to have_content('ユーザー名を入力してください')
        end
      end
    end
  end

  describe 'ログイン' do
    let!(:user) { create(:user) }

    context '正常な入力の場合' do
      it 'ログインできること', js: true do
        visit new_user_session_path
        fill_in 'ユーザー名', with: user.name
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'ログインしました'
      end
    end

    context '不正な入力の場合' do
      it 'エラーメッセージが表示されること', js: true do
        visit new_user_session_path
        fill_in 'ユーザー名', with: user.name
        fill_in 'パスワード', with: 'wrong_password'
        click_button 'ログイン'
        expect(page).to have_content '無効なユーザー名またはパスワードです'
      end
    end
  end
end
