require File.dirname(__FILE__) + "/helper"

steps_for(:view_homepage) do
    
  
  #####
  # Contexts
  
  Given "a new company" do
    @company = Company.create!(company_valid_fields)
  end
  
  Given "$count new companies" do |count|
    @companies = []
    count.to_i.times do |i|
      company = new_company(:created_at => Time.now + i)
      company.name = "#{company.name}_#{(i + 1).to_s}_ende"
      company.save!
      @companies << company
    end
  end
  
  #####
  # Actions
  
  When "I request $path" do |path|
    get path
  end
  
  
  #####
  # Assertions
  
  Then "I want to get a successful response" do
    response.should be_success
  end
  
  Then "I want to see the latest companies" do
    assigns(:newest_companies).should_not be_nil
  end
  
  Then "the latest $count companies should be shown" do |count|
    
    count.to_i.times do
      response.body.should match(%r"#{@companies.pop.name}")
    end
    
  end
  
  Then "the other companies should not be shown" do
    @companies.each do |company|
      response.body.should_not match(%r"#{company.name}")
    end
  end
  
end


with_steps_for(:view_homepage) do
  run_local_story "homepage_story", :type => RailsStory
end