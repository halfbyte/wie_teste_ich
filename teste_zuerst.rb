# - Test-Driven und nicht Test-Supported (oder BDD, philosophischer Unterschied)
# - das gilt vor allem auch für Bugs!

# Warum?
# - weil man einen anderen Blickwinkel auf seine Anwendung bzw. auf die Schnittstelle hat;
#   dient der Reflektion über notwendiges Verhalten und notwendigen Code
# - weil man weniger die Implementierung testet, und eher das Verhalten; nachgelagerte 
#   Tests testen entweder zu viel oder zu wenig

# Probleme
# - man testet zu integrativ und zu wenig isoliert
#   -> man kann seine Tests ja später optimieren
#   -> Erfahrung hilft

# Beispiel (soll auch die Notation einführen)
# zuerst beschreibt man, wie der Benutzer sich verhalten soll
describe "A user's display name" do
  it "should equal his/her login if no other name is available" do
  end
  it "should equal his/her full name if available" do 
  end
end

# dann füllt man das Ganze mit Leben
describe "A user's display name" do
  it "should equal his/her login name if no other is available" do
    user = User.new(:login => 'dude')
    user.display_name.should eql('dude')
  end
  it "should equal his/her full name if available" do 
    user = User.new(:login => 'dude', :name => 'Thorsten Böttger')
    user.display_name.should eql('Thorsten Böttger')
  end
end

# und dann sieht man zu, dass der Benutzer das auch tut
# user.rb
class User < ActiveRecord::Base
  def display_name
    name.blank? ? login : name
  end
end
