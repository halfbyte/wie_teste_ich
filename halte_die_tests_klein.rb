# - eine Assertion pro Test? DOGMA!!!!

# Warum?
# - lesbarer
# - man konzentriert sich eher auf das was man testen möchte (ausgedrückt im it-Text)
# - man weiss nicht, wie sehr kaputt der Test wirklich ist

# so nicht!
describe "A user's display name" do
  it "should reflect the user's name" do
    user = User.new(:login => 'alto')
    user.display_name.should eql('alto')
    
    user.firstname = 'Thorsten'
    user.display_name.should eql('Thorsten')

    user.lastname = 'Böttger'
    user.display_name.should eql('Thorsten Böttger')
  end
end

# eher so
describe "A user's display name" do
  before do
    @user = User.new(:login => 'alto')
  end
  it "should equal the login name if no other name is given" do
    @user.display_name.should eql('alto')
  end
  it "should equal his firstname if it is given" do
    @user.firstname = 'Thorsten'
    @user.display_name.should eql('Thorsten')
  end
  it "should equal his fullname if firstname and lastname are given" do
    @user.firstname = 'Thorsten'
    @user.lastname = 'Böttger'
    @user.display_name.should eql('Thorsten Böttger')
  end
end
