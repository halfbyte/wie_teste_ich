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
    @jan      = User.create(:name => 'Jan')
    @thorsten = User.create(:name => 'Thorsten')
    @urs      = User.create(:name => 'Urs')
    @deleted  = User.create(:name => 'Deleted', :deleted_at => Time.now)
  end
  it "should deliver active users" do
    users = User.find_active
    users.should include(@jan)
    users.should include(@thorsten)
    users.should include(@urs)
  end
  it "should deliver active users, sorted by name ascending" do
    User.find_active(:order => 'name ASC').should eql([@jan, @thorsten, @urs])
  end
  it "should deliver active users, sorted by name descending" do
    User.find_active(:order => 'name DESC').should eql([@urs, @thorsten, @jan])
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
describe "Finding active users" do
  before do
    @jan      = User.create(:name => 'Jan',       :points => 2)
    @thorsten = User.create(:name => 'Thorsten',  :points => 1)
    @urs      = User.create(:name => 'Urs',       :points => 0)
    @deleted  = User.create(:name => 'Deleted',   :points => 1, :deleted_at => Time.now)
  end
  it "should deliver active users" do
    users = User.find_active
    users.should include(@jan)
    users.should include(@thorsten)
    users.should include(@urs)
  end
  it "should deliver active users, sorted by name ascending" do
    User.find_active(:order => 'name ASC').should eql([@jan, @thorsten, @urs])
  end
  it "should deliver active users, sorted by name descending" do
    User.find_active(:order => 'name DESC').should eql([@urs, @thorsten, @jan])
  end
end

# -> besser
describe "Finding active users" do
  before do
    @jan      = User.create(:name => 'Jan',       :points => 2)
    @thorsten = User.create(:name => 'Thorsten',  :points => 1)
    @urs      = User.create(:name => 'Urs',       :points => 0)
    @deleted  = User.create(:name => 'Deleted',   :points => 1, :deleted_at => Time.now)
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
