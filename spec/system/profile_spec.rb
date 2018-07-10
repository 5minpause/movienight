require "rails_helper"

RSpec.feature "Profile", type: :feature do
  before(:each) do
    @user ||= create(:user, profile: nil)
    login_as @user, scope: :user
  end

  scenario "User can create a profile" do
    visit new_profile_path
    fill_in "First name", with: "Francesco"
    fill_in "Last name", with: "Mari"
    fill_in "Nickname", with: "sekmo"

    click_on "Create Profile"

    expect(current_path).to eql(new_wish_path)
    expect(page).to have_content "Profile was successfully created. Now create your wishlist!"
  end

  scenario "User can update her profile" do
    @profile = create(:profile, user: @user, first_name: "Francesco", last_name: "Mari",
      nickname: "sekmo")
    visit edit_profile_path(@profile)

    fill_in "First name", with: "Mario"
    fill_in "Last name", with: "Rossi"
    fill_in "Nickname", with: "marione"

    expect{
      click_on "Update Profile"
      @profile.reload
    }.to change  { @profile.first_name }.from("Francesco").to("Mario")
     .and change { @profile.last_name }.from("Mari").to("Rossi")
     .and change { @profile.nickname }.from("sekmo").to("marione")
  end

  scenario "User cannot visit the new profile page if she already have a profile" do
    @profile = create(:profile, user: @user, first_name: "Francesco", last_name: "Mari",
      nickname: "sekmo")
    visit new_profile_path
    expect(page).to have_content "You already have a profile. Create your wishlist!"
    expect(current_path).to eql(new_wish_path)
  end
end
