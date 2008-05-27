# - nicht Plugins, Gems oder gar Rails selber
# * Keinen Framework-Code Testen
#   * Assoziationen
#     * reflect_on
#     * respond_to reicht nicht aus, weil has_one/belongs_to nicht trennbar ist über den assoc-proxy
#     -> screencast gucken
#     -> Plugin extrahieren
#   * Validations
#     * validation_reflections
# TODO: was meinst du mit den Punkten? [thorsten, 27.05.2008]

# Warum?
# - weil diese schon - zumindest meistens ;-) - gut genug getestet sind
# - neu ist doch nur der eigene Code

# Probleme:
# - woran macht man fest, dass man nur den eigenen Code testet?

# hier testen wir Rails
describe "A user" do
  it "should be findable" do
    user = User.create(:name => 'dude')
    User.find_by_name('dude').should eql(user)
  end
end

# es sei denn, die find_by_login-Methode haben wir selber geschrieben
class User < ActiveRecord::Base
  def self.find_by_name(name)
    find(:first, :conditions => ['name = :name OR login = :name', {:name => name}])
  end
end

# aber dann müssen wir auch zwei Tests schreiben
describe "A user" do
  it "should be findable by his/her name" do
    user = User.create(:name => 'dude')
    User.find_by_name('dude').should eql(user)
  end
  it "should be findable by his/her login" do
    user = User.create(:login => 'dude')
    User.find_by_name('dude').should eql(user)
  end
end
