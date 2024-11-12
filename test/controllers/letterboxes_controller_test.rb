require "test_helper"

class LetterboxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @letterbox = letterboxes(:one)
  end

  test "should get index" do
    get letterboxes_url
    assert_response :success
  end

  test "should get new" do
    get new_letterbox_url
    assert_response :success
  end

  test "should create letterbox" do
    assert_difference("Letterbox.count") do
      post letterboxes_url, params: { letterbox: { title: @letterbox.title } }
    end

    assert_redirected_to letterbox_url(Letterbox.last)
  end

  test "should show letterbox" do
    get letterbox_url(@letterbox)
    assert_response :success
  end

  test "should get edit" do
    get edit_letterbox_url(@letterbox)
    assert_response :success
  end

  test "should update letterbox" do
    patch letterbox_url(@letterbox), params: { letterbox: { title: @letterbox.title } }
    assert_redirected_to letterbox_url(@letterbox)
  end

  test "should destroy letterbox" do
    assert_difference("Letterbox.count", -1) do
      delete letterbox_url(@letterbox)
    end

    assert_redirected_to letterboxes_url
  end
end
