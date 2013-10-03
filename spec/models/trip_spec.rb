# == Schema Information
#
# Table name: trips
#
#  id              :integer          not null, primary key
#  trip_id         :integer
#  title           :string(255)
#  destination     :string(255)
#  start_date      :date
#  end_date        :date
#  destination_lat :float
#  destination_lng :float
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'


describe Trip do
  
  let(:user) { FactoryGirl.create(:user) }

before { @trip = user.trips.build(trip_id: "1", title: "welcome to app", destination: "xyz", start_date: "18-06-1991", end_date: "20-06-1991", destination_lat: "10.0", destination_lng: "20.0") }
  

    subject { @trip}

  it { should respond_to(:trip_id) }
  it { should respond_to(:title) }
  it { should respond_to(:destination) }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:destination_lat) }
  it { should respond_to(:destination_lng) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
 
 

    it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Trip.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

    
   describe "when user_id not present" do
    before { @trip.user_id = nil }
    it { should_not be_valid }
  end
  
  
  describe "when trip_id not present" do
    before { @trip.trip_id = " " }
    it { should_not be_valid }
  end
  
  describe "when title not present" do
    before { @trip.title = " " }
    it { should_not be_valid }
  end
  
  describe "when destination not present" do
    before { @trip.destination = " " }
    it { should_not be_valid }
  end
  
  describe "when start_date not present" do
    before { @trip.start_date = " " }
    it { should_not be_valid }
  end
  
  describe "when end_date not present" do
    before { @trip.end_date = " " }
    it { should_not be_valid }
  end
  
  describe "when destination_lat not present" do
    before { @trip.destination_lat = " " }
    it { should_not be_valid }
  end
  
  describe "when destination_lng not present" do
    before { @trip.destination_lng = " " }
    it { should_not be_valid }
  end
  
end


