require "test_helper"

class SignUpUserTest < ActionDispatch::IntegrationTest

  test "sign up user with correct credentials" do
    get "/signup"
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: "TestUser", email: "testmail@test.mail", password: "testpassword" } }
    end
    follow_redirect!
    assert_response :success
    assert_match "TestUser", response.body
    assert_select 'nav.navbar'
  end


  test "get the new user form and reject invalid user name" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: " ", email: "testmail@test.mail", password: "testpassword" } }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end

  test "get the new user form and reject invalid user mail" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "TestUser", email: "testmailtest.mail", password: "testpassword" } }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end

end
