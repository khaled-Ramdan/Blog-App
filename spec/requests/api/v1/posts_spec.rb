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


RSpec.describe "Posts", type: :request do
  let(:user) { FactoryBot.create(:user) } # create a valid user
  let(:token) { JwtService.encode(user_id: user.id) } # generate JWT for the user
  let (:post) { FactoryBot.create(:post, user: user) } # crerate a valid post

  describe "GET /posts" do
    it "return all posts" do
      get "/api/v1/posts", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include("success" => true)
    end

    it_behaves_like "unauthorized access", :get do
      let(:request_path) { "/api/v1/posts" }
    end
  end

  describe "GET /show" do
    it "returns wanted post" do
      get "/api/v1/posts/#{post.id}",  headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include("success" => true)
    end

    it_behaves_like "unauthorized access", :get do
      let(:request_path) { "/api/v1/posts/#{post.id}" }
    end
  end


  # describe "POST /posts" do
  #   it "creates a new post" do
  #     post "/api/v1/posts",
  #         params: { post: { title: "New Post", body: "Post body", tags: "tag1" } },
  #         headers: { "Authorization" => "Bearer #{token}" }

  #     expect(response).to have_http_status(:created)
  #     expect(JSON.parse(response.body)["data"]["title"]).to eq("New Post")
  #   end

  #   it_behaves_like "unauthorized access", :post do
  #     let(:request_path) { "/api/v1/posts" }
  #   end
  # end


  describe "GET /edit" do
    it "returns http success" do
      get "/api/v1/posts/#{post.id}/edit",
      params: { post: { body: "new body" } },
      headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include("success" => true)
      expect(JSON.parse(response.body)["data"]).to include("body" => "new body")
    end

    it_behaves_like "unauthorized access", :get do
      let(:request_path) { "/api/v1/posts/#{post.id}/edit" }
    end
  end

  # describe "GET /update" do
  # it "returns http success" do
  # not implemented yet
  # get "api/v1/posts/update"
  # expect(response).to have_http_status(:success)
  # end
  # end

  describe "GET /destroy" do
    it "returns http success" do
      mypost =  FactoryBot.create(:post, user: user)
      inital_count = Post.count
      delete "/api/v1/posts/#{mypost.id}", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
      expect(Post.count).to eq(inital_count - 1)
    end

    it_behaves_like "unauthorized access", :delete do
      let(:request_path) { "/api/v1/posts/#{post.id}" }
    end
  end
end
