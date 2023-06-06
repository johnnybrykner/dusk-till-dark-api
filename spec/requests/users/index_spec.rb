# spec/requests/root_spec.rb

RSpec.describe "GET /users", type: :request do
  it "returns a list of users" do
    get "/users"

    expect(last_response).to be_successful
    expect(last_response.content_type).to eq("application/json; charset=utf-8")

    response_body = JSON.parse(last_response.body)

    expect(response_body).to be_an(Array)
  end
end
