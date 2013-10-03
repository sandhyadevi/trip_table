# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  username        :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_token  :string(255)
#  password_digest :string(255)
#  admin           :boolean          default(FALSE)
#

require 'spec_helper'

describe User do

	before do 
		@user = User.new(name: "Example User", username: "user@example.com", 
		password: "foobar", password_confirmation: "foobar") 
	end

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:username) } 
    it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:admin) }
	 it { should respond_to(:trips) }

	it { should be_valid }

	describe "when name is not present" do
		before { @user.name = " "}
		it { should_not be_valid }
	end

	describe "when username is not present" do
		before { @user.username = " "}
		it { should_not be_valid }
	end

	#You can change this, the limit can be whatever you choose
	describe "when name is too long" do
		before { @user.name = "a"*16 }
		it { should_not be_valid }
	end

	describe "when username format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.username = valid_address
				@user.should be_valid
			end
		end
	end

	describe "when username address is already taken" do
		before do
			user_with_same_username = @user.dup
			user_with_same_username.username = @user.username.upcase
			user_with_same_username.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " "}
		it { should_not be_valid}
	end

	describe "when password does not match confirmation" do
		before { @user.password_confirmation = "this_does_not_match_the_original_password" }
		it { should_not be_valid }
	end

	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "return value of authenticate method" do
  		before { @user.save }
  		
 		let(:found_user) { User.find_by_username(@user.username) }

  		describe "with valid password" do
    		it { should == found_user.authenticate(@user.password) }
  		end

  		describe "with invalid password" do
    		let(:user_for_invalid_password) { found_user.authenticate("invalid") }

    		it { should_not == user_for_invalid_password }
    		specify { user_for_invalid_password.should be_false }
  		end
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" *5 }
		it { should be_invalid }
	end

	describe "username with mixed cases" do
		
		it " should be all lower case " do
			@user.username = mixed_case_username
			@user.save
			@user.reload.username.should == mixed_case_username.downcase
		end
	end
	describe "trip associations" do
  
    before { @user.save }
    let!(:older_trip) do 
      FactoryGirl.create(:trip, user: @user)
    end
    let!(:newer_trip) do
      FactoryGirl.create(:trip, user: @user)

    it "should have the right trips in the right order" do
      @user.trips.should == [newer_trip, older_trip]
    end
  end
  it "should destroy associated trips" do
      trips = @user.trips.to_a
      @user.destroy
      expect(trips).not_to be_empty
      trips.each do |trip|
        expect(Trip.where(id: trip.id)).to be_empty
      end
    end
end
end
