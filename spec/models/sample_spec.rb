require "rails_helper"

RSpec.describe Sample, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_most(24) }
end
