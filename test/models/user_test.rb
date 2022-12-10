require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "should save user with hex" do
    random_int = (rand * 1e10).to_i
    hex_address = IntToHexAddressConverter.call(random_int)
    user = User.new({klaytn_address: hex_address})
    assert(user.save)
  end

  test "should not create user with duplicate address" do
    hex_address = User.last.klaytn_address
    assert_raises(ActiveRecord::RecordNotUnique) {
      User.create({klaytn_address: hex_address})
    }
  end

  test "should not save user with address length not 40" do
    ((0..39).to_a+(41..80).to_a).each do |n|
      user = User.new({klaytn_address: "0" * n})
      assert_not(user.save)
    end 
  end

end
