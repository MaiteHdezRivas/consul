require 'rails_helper'

describe Banner do
  let(:banner) { build(:banner) }

  it "is valid" do
    expect(banner).to be_valid
  end

  describe "#title" do
    it "isn't valid without a title" do
      banner.title = nil
      expect(banner).to_not be_valid
    end
    it "isn't valid when very short" do
      banner.title = "a"
      expect(banner).to_not be_valid
    end
  end

  it "isn't valid without a description" do
    banner.description = nil
    expect(banner).to_not be_valid
  end

  it "isn't valid without a target_url" do
    banner.target_url = nil
    expect(banner).to_not be_valid
  end

  it "isn't valid without a style" do
    banner.style = nil
    expect(banner).to_not be_valid
  end

  it "isn't valid without a image style" do
    banner.image = nil
    expect(banner).to_not be_valid
  end

  it "isn't valid without a post_started_at" do
    banner.post_started_at = nil
    expect(banner).to_not be_valid
  end
  
  it "isn't valid without a post_ended_at" do
    banner.post_ended_at = nil
    expect(banner).to_not be_valid
  end
end
