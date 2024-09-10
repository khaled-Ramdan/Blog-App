require 'rails_helper'


# Test for JWT authentication
RSpec.shared_examples "unauthorized access" do |request_method|
  it "returns http unauthorized" do
    send(request_method, request_path, headers: { "Authorization" => "Bearer invalid_token" })
    expect(response).to have_http_status(:unauthorized)
    expect(JSON.parse(response.body)).to include("success" => false)
    expect(JSON.parse(response.body)).to include("errors" => "Unauthorized")
  end
end



RSpec.describe "Api::V1::Comments", type: :request do
  let(:user) { FactoryBot.create(:user) } # create a valid user
  let(:otherUser) { FactoryBot.create(:user, email: "test@example2.com") } # create another user
  let(:token) { JwtService.encode(user_id: user.id) } # generate JWT for the user
  let (:mypost) { FactoryBot.create(:post, user: user) } # crerate a valid post
  let (:otherUserPost) { FactoryBot.create(:post, user: otherUser) } # crerate a valid post
  let (:mycomment) { FactoryBot.create(:comment, user: user, post: mypost) } # crerate a valid comment
  let (:otherUserComment) { FactoryBot.create(:comment, user: otherUser, post: otherUserPost) } # crerate a valid comment


  describe "GET /index" do
    let(:request_path) { "/api/v1/post/#{mypost.id}/comments" }
    let(:bad_request_path) { "/api/v1/post/wrong_id/comments" }
    it "returns all comments for given post" do
      get request_path, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("success" => true)
    end

    it_behaves_like "unauthorized access", :get do
      let(:request_path) {  "/api/v1/post/#{mypost.id}/comments" }
    end

    it "wrong post id" do
      get bad_request_path, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to include("success" => false)
      expect(JSON.parse(response.body)).to include("errors")
    end
  end


  describe "POST /create" do
    let(:request_path) { "/api/v1/post/#{mypost.id}/comments" }
    let(:bad_request_path) { "/api/v1/post/wrong_id/comments" }
    it "create new comment for given post" do
      initial_count = Comment.count
      post request_path,
      headers: { "Authorization" => "Bearer #{token}" },
      params: { comment: { body: "new comment" } }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include("success" => true)
      expect(JSON.parse(response.body)).to include("data")
      expect(Comment.count).to eq(initial_count + 1)
    end

    it_behaves_like "unauthorized access", :post do
      let(:request_path) { "/api/v1/post/#{mypost.id}/comments" }
    end

    it "wrong post id" do
      get bad_request_path, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to include("success" => false)
      expect(JSON.parse(response.body)).to include("errors")
    end
  end

  describe "GET /edit" do
    let(:request_path) { "/api/v1/post/#{mypost.id}/comments/#{mycomment.id}/edit" }
    let(:bad_request_path_1) { "/api/v1/post/wrong_id/comments/#{mycomment.id}/edit" }
    let(:bad_request_path_2) { "/api/v1/post/#{mypost.id}/comments/wrong_id/edit" }
    it "Edit your comment for given post" do
      get request_path,
            headers: { "Authorization" => "Bearer #{token}" },
            params: { comment: { body: "new comment" } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("data")
      expect(JSON.parse(response.body)["data"]).to include("body" => "new comment")
    end

    it_behaves_like "unauthorized access", :get do
      let(:request_path) { "/api/v1/post/#{mypost.id}/comments/#{mycomment.id}/edit" }
    end

    it "wrong post id" do
      get bad_request_path_1, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to include("success" => false)
      expect(JSON.parse(response.body)).to include("errors")
    end

    it "wrong comment id" do
      get bad_request_path_1, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to include("success" => false)
      expect(JSON.parse(response.body)).to include("errors")
    end

    it "try to edit a comment for a different user" do
      get "/api/v1/post/#{otherUserPost.id}/comments/#{otherUserComment.id}/edit",
      headers: { "Authorization" => "Bearer #{token}" },
      params: { comment: { body: "new comment" } }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to include("success" => false)
      expect(JSON.parse(response.body)).to include("errors"=>"Unauthorized")
    end
  end


  describe "GET /destroy" do
    let(:request_path) { "/api/v1/post/#{mypost.id}/comments/#{mycomment.id}" }
    let(:bad_request_path_1) { "/api/v1/post/wrong_id/comments/#{mycomment.id}" }
    let(:bad_request_path_2) { "/api/v1/post/#{mypost.id}/comments/wrong_id" }
    it "returns http success" do
      mycomment2 = FactoryBot.create(:comment, user: user, post: mypost)
      inital_count = Comment.count
      delete "/api/v1/post/#{mypost.id}/comments/#{mycomment2.id}", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:no_content)
      expect(Comment.count).to eq(inital_count - 1)
    end

    it_behaves_like "unauthorized access", :delete do
      let(:request_path) { "/api/v1/post/#{mypost.id}/comments/#{mycomment.id}" }
    end

    it "wrong post id" do
      delete bad_request_path_1, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to include("success" => false)
      expect(JSON.parse(response.body)).to include("errors")
    end

    it "wrong comment id" do
      delete bad_request_path_1, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to include("success" => false)
      expect(JSON.parse(response.body)).to include("errors")
    end


    it "try to delete a comment for a different user" do
      delete "/api/v1/post/#{otherUserPost.id}/comments/#{otherUserComment.id}",
      headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to include("success" => false)
      expect(JSON.parse(response.body)).to include("errors"=>"Unauthorized")
    end
  end
end
