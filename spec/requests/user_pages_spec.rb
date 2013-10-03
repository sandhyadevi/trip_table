require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", username: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", username: "ben@example.com")
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
        it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      let(:first_page)  { User.paginate(page: 1) }
      let(:second_page) { User.paginate(page: 2) }

      it { should have_link('Next') }
      its(:html) { should match('>2</a>') }

      it "should list each user" do
        User.all[0..2].each do |user|
          page.should have_selector('li', text: user.name)
        end
      end

      it "should list the first page of users" do
        first_page.each do |user|
          page.should have_selector('li', text: user.name)
        end
      end

      it "should not list the second page of users" do
        second_page.each do |user|
          page.should_not have_selector('li', text: user.name)
        end
      end

      describe "showing the second page" do
        before { visit users_path(page: 2) }

        it "should list the second page of users" do
          second_page.each do |user|
            page.should have_selector('li', text: user.name)
          end
        end
      end 
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
	let!(:m1) { FactoryGirl.create(:trip, user: user, trip_id: "2", title: "abc", destination: "vizag", start_date: "10-2-2013", end_date: "21-2-2013", destination_lat: "20.2", destination_lng: "30.2") }
	let!(:m2) { FactoryGirl.create(:trip, user: user, trip_id: "3", title: "xyz", destination: "hyd", start_date: "10-2-2013", end_date: "21-2-2013", destination_lat: "20.2", destination_lng: "30.2") }
    
    
    before { visit user_path(user) }

    it { should have_trip_id(user.name) }
	it { should have_title(user.name) }
	it { should have_destination(user.name) }
	it { should have_start_date(user.name) }
	it { should have_end_date(user.name) }
	it { should have_destination_lat(user.name) }
	it { should have_destination_lng(user.name) }
	
    it { should have_title(user.name) }

	 describe "trips" do
      it { should have_trip_id(m2.trip_id) }
	  it { should have_title(m2.title) }
	  it { should have_destination(m2.destination) }
	  it { should have_start_date(m2.start_date) }
	  it { should have_end_date(m2.end_date) }
	  it { should have_destination_lng(m2.destination_lat) }
	  it { should have_trip_id(m2.trip_id) }
	  it { should have_title(m2.title) }
	  it { should have_destination(m2.destination) }
	  it { should have_start_date(m2.start_date) }
	  it { should have_end_date(m2.end_date) }
	  it { should have_destination_lng(m2.destination_lat) }
      
      it { should have_trip_id(user.trips.count) }
	  it { should have_title(user.trips.count) }
	  it { should have_destination(user.trips.count) }
	  it { should have_start_date(user.trips.count) }
	  it { should have_end_date(user.trips.count) }
	  it { should have_destination_lat(user.trips.count) }
	  it { should have_destination_lng(user.trips.count) }
    end
   
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "error messages" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Username",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    
      describe "after saving the user" do
        before { click_button submit }
        
        let(:user) { User.find_by_username('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end
    
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/usernames') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_username) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Username",            with: new_username
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.username.should == new_username }
    end
  end

  
end