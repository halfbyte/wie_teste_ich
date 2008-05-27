# - sondern nur das Entscheidende
# - dabei sollte man schon jeden Code testen, oder?

# Warum?
# - weil man sonst nicht mehr implementiert, sondern nur noch Tests schreibt; es kostet 
#   einfach zu viel Zeit!
# - nicht mehr tuen als nötig
# - gut genug, pragmatisch

# Probleme
# - wie finde ich das? wann ist es gut genug?
#   -> Erfahrung, Gefühl entwickeln
#   -> bewährt haben sich:

# a) der Erfolgsfall
describe "A user" do
  it "should have a valid email address" do
    user = User.new(:email => 'thorsten@test.de')
    user.should be_valid
  end
end

# b) Negativtest (Ausnahmen und Fehlerfälle)
describe "A user" do
  it "should have a valid email address" do
    user = User.new(:email => 'thorsten@test.de')
    user.should be_valid
  end
  it "should be invalid with an invalid email address" do
    user = User.new(:email => 'thorsten@test')
    user.should_not be_valid
  end
end

# jetzt wird es interessant: natürlich sind das nicht alle möglichen gültigen und ungültigen Emailadressen!
# -> also
describe "A user" do
  it "should have a valid email address" do
    user = User.new(:email => 'test@test.de')
    user.should be_valid
  end
  it "should be invalid with an invalid email address 1" do
    user = User.new(:email => 'test@test')
    user.should_not be_valid
  end
  it "should be invalid with an invalid email address 2" do
    user = User.new(:email => 'testtest.de')
    user.should_not be_valid
  end
end

# oder zusammengefasst
describe "A user" do
  it "should have a valid email address" do
    valid_emails.each do |valid_email|
      user = User.new(:email => valid_email)
      user.should be_valid
    end
  end
  it "should be invalid with an invalid email address" do
    invalid_emails.each do |invalid_email|
      user = User.new(:email => invalid_email)
      user.should_not be_valid
    end
  end
  
  def valid_emails
    ['test@test.com','test@test.test.test.com','test.test@test.com','test-test@test-test.com','test_test@test_test.com']
  end
  def invalid_emails
    ['test@test','testtest.com','@test.com','täst@test.com','test me@test.de']
  end
end

# aber wann ist es genug?
# wichtig ist aber, dass man alle selbstgeschrieben Stellen einmal antestet; vollständig testen ist absurd
