ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails/story_adapter'
require RAILS_ROOT + "/spec/rspec_helper"

def run_local_story(filename, options={})
  run File.join(File.dirname(__FILE__), 'stories_plain_text', filename), options
end



def login(login, password)
  post "/sessions/create", :login => login, :password => password
end

def create_and_login_as_applicant(options = {:login => 'dude', :password => 'test', :password_confirmation => 'test', :email => 'a@b.de'})
  @user = create_user(options)
  login(@user.login, options[:password])
  @user.has_role 'applicant'
  @user.create_applicant_profile(:forename => 'dude', :surname => 'sweet')
end

def create_and_login_as_company(options = {:login => 'dude', :password => 'test', :password_confirmation => 'test', :email => 'a@b.de', :type_role => 'company'})
  @user = create_user(options)
  login(@user.login, options[:password])
  @user.has_role 'company'
  @user.create_company(company_valid_fields)
end

def destroy_session
  delete "sessions/destroy"
end
