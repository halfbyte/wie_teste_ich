require File.dirname(__FILE__) + "/helper"

steps_for(:creation_deletion_and_show_of_bookmarks) do
  
  #####
  # Contexts
  
  Given "the user is logged in" do
    login
  end

  Given "the user is not logged in" do
    destroy_session
  end

  Given "the company exists" do
    @company = create_company
  end
  
  Given "the watchlist contains at least 1 bookmark" do
    @user.add_bookmark(@company)
  end
  
  Given "the watchlist contains the company already" do
    @user.add_bookmark(@company)
  end
  
  #####
  # Actions
  
  When "he tries to view his bookmarks" do
    get '/bookmarks'
  end
  
  When "he tries to add a company to his bookmarks" do
    post "/bookmarks?company_id=#{@company.id}"
  end
  
  When "he tries to remove a bookmark from his watchlist" do
    delete "/bookmarks/" + @company.id.to_s
  end
  
  #####
  ## Assertions
  
  Then "the response should be successful" do
    response.should be_success
  end
  
  Then "the company should be added to his bookmarks" do
    @user.companies.should include(@company)
  end
  
  Then "the bookmark should not be added to the watchlist" do
    @user.companies.select{|x| x.id == @company.id}.size.should == 1
  end
  
  Then "the user should be redirected to the bookmarks page" do
    response.should redirect_to('/bookmarks')
  end
  
  Then "the user should be redirected to the company page" do
    response.should redirect_to('/companies/' + @company.id.to_s)
  end
  
  Then "the status message should be '$message'" do |message|
    flash[:notice].should match(/#{message}/)
  end
  
  Then "the bookmark should be removed from the users watchlist" do
    controller.send(:current_user).companies.should_not include(@company)
  end
  
  Then "the response should be redirect" do
    response.should be_redirect
  end
  
end

with_steps_for(:creation_deletion_and_show_of_bookmarks) do
  run_local_story "bookmark_story", :type => RailsStory
end