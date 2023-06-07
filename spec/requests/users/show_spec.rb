# spec/requests/books/show_spec.rb

RSpec.describe "GET /users/:username", type: [:request, :database] do
  context "when a user matches the given id" do
    it "gets the user" do
      get "/users/Default"

      expect(last_response).to be_successful
      expect(last_response.content_type).to eq("application/json; charset=utf-8")

      response_body = JSON.parse(last_response.body)

      expect(response_body).to be_an(Object)
    end
  end

  context "when no user matches the given id" do
    it "returns not found" do
      get "/users/FakeUser"

      expect(last_response).to be_not_found
      expect(last_response.content_type).to eq("application/json; charset=utf-8")

      response_body = JSON.parse(last_response.body)

      expect(response_body).to eq(
        "error" => "User not found"
      )
    end
  end
end
