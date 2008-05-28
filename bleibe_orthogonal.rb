# - teste Logik nur einmal

# Warum?
# - um zu vermeiden, dass man bei Änderung des Codes/des Verhaltens viele Tests anfassen muss

# Beispiel
class User < ActiveRecord::Base
  def self.find_active(options={})
    find_options = {:conditions => 'deleted_at IS NULL'}
    find_options[:order] = options[:order] if options[:order]
    find(:all, find_options)
  end
end

# unorthogonale Tests
describe "Finding active users" do
  before do
    @jan      = User.create(:login => 'krutisch', :name => 'Jan')
    @thorsten = User.create(:login => 'boettger', :name => 'Thorsten')
    @dude     = User.create(:login => 'dude',     :name => 'dude', :deleted_at => Time.now)
  end
  it "should deliver active users" do
    users = User.find_active
    users.should include(@jan)
    users.should include(@thorsten)
  end
  it "should deliver active users, sorted by login" do
    User.find_active(:order => 'login ASC').should eql([@thorsten, @jan])
  end
  it "should deliver active users, sorted by name" do
    User.find_active(:order => 'name ASC').should eql([@jan, @thorsten])
  end
end
# -> wenn ich jetzt eine weitere Bedingung für Aktivität hinzufüge und das mittesten
#    möchte, dann muss ich gleich drei Tests anpassen!

class User < ActiveRecord::Base
  def self.find_active(options={})
    find_options = {:conditions => 'deleted_at IS NULL AND points > 0'}
    find_options[:order] = options[:order] if options[:order]
    find(:all, find_options)
  end
end

# huhu, wir müssten drei Tests anpassen, weil wir natürlich diese neue Bedingung mittesten wollen
# -> besser
describe "Finding active users" do
  before do
    @jan      = User.create(:login => 'krutisch', :name => 'Jan',      :points => 1)
    @thorsten = User.create(:login => 'boettger', :name => 'Thorsten', :points => 2)
    @dude     = User.create(:login => 'dude',     :name => 'dude',     :deleted_at => Time.now)
    @lazy     = User.create(:login => 'lazy',     :name => 'lazy',     :points => 0)
  end
  it "should deliver undeleted users" do
    User.find_active.each {|user| user.should_not be_deleted}
  end
  it "should deliver users with at least one point" do
    User.find_active.each {|user| user.points.should > 0}
  end
  it "should deliver active users, sorted by login" do
    User.find_active(:order => 'login ASC').each_cons(2) {|couple| couple[0].login <= couple[1].login}
  end
  it "should deliver active users, sorted by name" do
    User.find_active(:order => 'name ASC').each_cons(2) {|couple| couple[0].name <= couple[1].name}
  end
end
