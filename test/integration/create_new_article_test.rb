require "test_helper"

class CreateNewArticleTest < ActionDispatch::IntegrationTest

    setup do
      @user = User.create(username:  "Johndoe", email: "johndoe@ex.com", password: "password")
      sign_in_as(@user)
    end

    test "get the new articles form and create new article" do
      get "/articles/new"
      assert_response :success
      assert_difference 'Article.count', 1 do
        post articles_path, params: { article: { title: "Test_title", description: "This is the text description of the test article", category: " "} }
        assert_response :redirect
      end
      follow_redirect!
      assert_response :success
      assert_match "Test_title", response.body
    end


    test "get the new articles form and reject invalid title article submission" do
      get "/articles/new"
      assert_response :success
      assert_no_difference 'Article.count' do
        post articles_path, params: { article: { title: " ", description: "This is the text description of the test article", category: " " } }
      end
      assert_match "Create a new Article", response.body
      assert_match "errors", response.body
      assert_select 'div.alert'
      assert_select 'h4.alert-heading'
    end

      test "get the new articles form and reject invalid category article submission" do
        get "/articles/new"
        assert_response :success
        assert_no_difference 'Article.count' do
          post articles_path, params: { article: { title: "test_title", description: " ", category: "" } }
        end
        assert_match "errors", response.body
        assert_select 'div.alert'
        assert_select 'h4.alert-heading'
        assert_match "Create a new Article", response.body
      end
end
