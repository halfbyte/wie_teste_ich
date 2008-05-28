# - eine Assertion pro Test? DOGMA!!!!

# Warum?
# - lesbarer
# - man konzentriert sich eher auf das was man testen möchte (ausgedrückt im it-Text)
# - man weiss nicht, wie sehr kaputt der Test wirklich ist

# so nicht!
describe "A user's role" do
  it "should be accessible" do
    user = User.new(:role => nil)
    user.should_not be_band
    user.role = 'user'
    user.should_not be_band
    user.role = 'band'
    user.should be_band
    user.role = 'admin'
    user.should_not be_band
  end
end

# eher so
describe "A user" do
  it "should be a band if that is his/her role" do
    user = User.new(:role => 'band')
    user.should be_band
  end
  it "should not be a band if his/her role is admin" do
    user = User.new(:role => 'admin')
    user.should_not be_band
  end
  it "should not be a band if his/her role is user" do
    user = User.new(:role => 'user')
    user.should_not be_band
  end
  it "should not be a band if his/her role is empty" do
    user = User.new(:role => nil)
    user.should_not be_band
  end
end
