require "test_helper"

class ListingTest < ActiveSupport::TestCase

  test "should generate hash on create default columns" do
    user = User.last
    listing = {
      title: "SBF",
      description: "R",
      user_id: user.id,
    }
    assert_raises(ActiveRecord::NotNullViolation) {
      Listing.create(listing)
    }
  end

  test "should generate hash on create" do
    user = User.last
    listing = {
      title: "SBF",
      description: "R",
      price: 1000000000000000000,
      deposit: 30000000000000000,
      bid_selected_block: 0,
      remonstrable_block_interval: 259200,
      user_id: user.id,
      status: 0,
    }
    listing = Listing.create(listing)
    assert_instance_of(Listing, listing)
    assert_equal(Hasher::Listing.call(listing), listing.hash_id)
  end

end
