  #######  
  ### => Generated by mindmatters_story_writer
  #######

  require File.dirname(__FILE__) + "/helper"


steps_for(:applicant_gets_the_dashboard_site) do
    
  Given "the user is logged in as applicant" do
    create_and_login_as_applicant
  end
  
  Given "companies and bookmarks are assigned" do
    company = create_company
    create_company
    @user.companies << company
  end
  
  When "he gets the dashboard" do
    get "/users/#{@user.id}/dashboard"
  end
  
  Then "the response should be success" do
    # puts response.headers.inspect
    response.should be_success
  end
  
  Then "the applicant dashboard page should be shown" do
    response.should render_template('dashboard/index')
  end
  
  Then "the shown page contains an profile-link" do
    response.should have_tag('a', 'Profil')
  end
  
  Then "the shown page contains an watchlist-link" do
    response.should have_tag('a', 'Beobachtete Unternehmen')
  end
  
  Then "the shown page doesn't contain an dashboard-link" do
    response.should_not have_tag('a', 'Dashboard')
  end
  
end

#### END OF applicant_gets_the_dashboard_site ####


steps_for(:applicant_gets_the_profile_site) do
  
  When "he gets the profile-site" do
    get "/applicant_profiles/#{@user.applicant_profile.id}/my_page"
  end
  
  Then "the applicant profile page should be shown" do
    response.should render_template('applicant_profiles/my_page')
  end
  
  Then "the shown page contains an dashboard-link" do
    response.should have_tag('a', 'Dashboard')
  end
  
  Then "the shown page doesn't contain an profile-link" do
    response.should_not have_tag('a', 'Profil')
  end
  
end

#### END OF applicant_gets_the_profile_site ####


steps_for(:applicant_gets_the_watchlist_site) do

  When "he gets the watchlist-site" do
    get "/bookmarks"
  end
  
  Then "the applicant watchlist-page should be shown" do
    response.should render_template('bookmarks/index')
  end
  
  Then "the shown page doesn't contain an watchlist-link" do
    response.should_not have_tag('a', 'Beobachtete Unternehmen')
  end
  
end

with_steps_for(:applicant_gets_the_dashboard_site, :applicant_gets_the_profile_site, :applicant_gets_the_watchlist_site) do
  run_local_story "applicant_dashboard_is_shown", :type => RailsStory
end
