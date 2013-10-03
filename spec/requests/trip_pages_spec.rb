require 'spec_helper'

describe "Trip pages" do

  subject { page }

  describe "trip page" do
    before { visit trip_path }

    it { should have_selector('h1',    text: 'Trip') }
    it { should have_selector('title', text: full_title('Trip')) }
  end
  
  describe "trip" do

    before { visit trip_path }

    let(:submit) { "Create trip" }

    describe "with invalid information" do
      it "should not create a trip" do
        expect { click_button submit }.not_to change(Trip, :count)
      end
    end

   
      it "should create a trip" do
        expect { click_button submit }.to change(Trip, :count).by(1)
      end
    end
  end


