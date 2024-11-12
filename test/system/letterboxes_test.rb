require "application_system_test_case"

class LetterboxesTest < ApplicationSystemTestCase
  setup do
    @letterbox = letterboxes(:one)
  end

  test "visiting the index" do
    visit letterboxes_url
    assert_selector "h1", text: "Letterboxes"
  end

  test "should create letterbox" do
    visit letterboxes_url
    click_on "New letterbox"

    fill_in "Title", with: @letterbox.title
    click_on "Create Letterbox"

    assert_text "Letterbox was successfully created"
    click_on "Back"
  end

  test "should update Letterbox" do
    visit letterbox_url(@letterbox)
    click_on "Edit this letterbox", match: :first

    fill_in "Title", with: @letterbox.title
    click_on "Update Letterbox"

    assert_text "Letterbox was successfully updated"
    click_on "Back"
  end

  test "should destroy Letterbox" do
    visit letterbox_url(@letterbox)
    click_on "Destroy this letterbox", match: :first

    assert_text "Letterbox was successfully destroyed"
  end
end
