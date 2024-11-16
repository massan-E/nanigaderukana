require "test_helper"

class StaticPageControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get static_page_top_url
    assert_response :success
  end
end
