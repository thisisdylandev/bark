require "rails_helper"

RSpec.describe Dog, type: :model do
  it "is valid with valid attributes" do
    newDog = FactoryBot.build(:dog)
    expect(newDog).to be_valid
  end

  it "should belong to a User" do
    newDog = FactoryBot.build(:dog)
    expect(newDog).to belong_to(:user)
  end

  it "is not valid without a user" do
    no_user = FactoryBot.build(:dog)
    no_user.user = nil
    expect(no_user).to_not be_valid
  end
end