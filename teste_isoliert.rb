# Warum?
# - um den Fehler nur in der Unit zu suchen und zu finden
# - mock und stub, um externe Systeme und lang laufende (oder forked) Prozesse zu vermeiden

# Probleme
# - ich laufe Gefahr, zu sehr die Implementierung zu testen
#   -> finde ein gutes Mittelmaß zwischen zu viel und zu wenig Gemocke
# - wenn ich die Implementierung ändere, muss ich die Tests anpassen, obwohl 
#   sich die Schnittstelle bzw. das Verhalten nicht geändert haben
#   -> Mittelmaß finden!

# --------------------------------------------------------------------------------------------------------
# schauen wir uns mal diesen Controller-Code an
class UsersController < ApplicationController
  def index
    @users = User.find_active
  end
end

# Test dazu
describe UsersController, "GET request on /users" do
  it "should deliver active users" do
    User.should_receive(:find_active).and_return(['user1','user2'])
    get index
    assigns(:users).should eql(['user1','user2'])
  end
end
# Ergebnis: kein Datenbankzugriff, nur Test des Controller-Codes


# --------------------------------------------------------------------------------------------------------
# Model-Beispiel: Youtube-Zugriff weggemockt
class Video < ActiveRecord::Base
  # hat eine youtube_video_id
  
  def validate
    response = Net::HTTP.start('youtube.com') { |http| http.head("/v/#{self.youtube_video_id}") }
    unless response.is_a?(Net::HTTPOK)
      errors.add(:youtube_video_id, "no valid Youtube Video ID")
    end
  end
end

# Test
describe Video, "validations" do
  before(:each) do
    @video = Video.new(:youtube_video_id => 'iY6VroKoB8E')
    http = mock('http')
    Net::HTTP.stub!(:start).and_yield(http)
    @response = mock('response')
    http.stub!(:head).and_return(@response)
  end
  it "should succeed with correct youtube video id" do
    @response.should_receive(:is_a?).with(Net::HTTPOK).and_return(true)
    @video.should be_valid
  end
  it "should fail with incorrect youtube video id" do
    @response.should_receive(:is_a?).with(Net::HTTPOK).and_return(false)
    @video.should_not be_valid
  end
end
# Ergebnis: sehr viel gemockt, und sehr dicht an der Implementierung

# --------------------------------------------------------------------------------------------------------
# ganz wild
class Project < ActiveRecord::Base
  def accessible_by?(user)
    owner_id == user.id
  end
end

class ProjectsController
  before_filter :login_required
  def show
    @project = Project.find(params[:id])
    redirect_to projects_path and return unless @project.accessible_by?(current_user)
  end
end

describe "GET request on /projects/1" do
  before do
    @project = Project.create
  end
  it "should redirect if user may not access the project" do
    @project.stub!(:accessible_by?).and_return(false)
    get :show, :id => @project.id
    response.should redirect_to(projects_path)
  end
end

# was passiert nun, wenn ich die Methode accessible_by? umbenenne?

