require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(6) }

  it "is valid with valid attributes" do
    user = User.new(username: "testuser", email: "user@test.com", password: "testpassword")
    expect(user).to be_valid
  end

  it "is not valid without a username" do
    user = User.new(username: nil, email: "user@test.com", password: "testpassword")
    expect(user).not_to be_valid
  end

  it "is not valid with a duplicate username" do
    User.create!(username: "testuser", email: "existing_user@test.com", password: "testpassword")
    user = User.new(username: "testuser", email: "user@test.com", password: "testpassword")
    expect(user).not_to be_valid
  end

  it "is not valid without an email" do
    user = User.new(username: "testuser", email: nil, password: "testpassword")
    expect(user).not_to be_valid
  end

  it "is not valid with a duplicate email" do
    User.create!(username: "existing_user", email: "user@test.com", password: "testpassword")
    user = User.new(username: "testuser", email: "user@test.com", password: "testpassword")
    expect(user).not_to be_valid
  end

  it "is not valid with an invalid email format" do
    user = User.new(username: "testuser", email: "invalid_email", password: "testpassword")
    expect(user).not_to be_valid
  end

end
