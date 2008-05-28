# Warum?
# - weil es ein gutes Gefühl gibt
# - damit du auch bei kleinen Änderungen noch weisst, dass du nichts kaputt gemacht hast
# - damit andere Entwickler wissen, dass sie nichts kaputt gemacht haben 
# - damit du weisst, was z.B. eine Unit eigentlich tuen soll (Verantwortung der Unit)
#   (führt zu besserem Design)

# Probleme
# - Testen kostet Zeit
#   -> das sieht auf den ersten Blick so aus, ja, ist aber nicht so; die späteren Vorteile
#      wiegen das mehr als auf
# - ich weiss nicht, wie ich testen soll

# vielleicht sollten wir diese Sonderfälle an späterer Stelle erläutern; ich denke, noch ist es zu früh
# welche Fälle kann man an dieser Stelle schon zeigen?

# --------------------------------------------------------------------------------------------------------
# Transaktionen
# bank_account.rb
class BankAccount < ActiveRecord::Base
  def transfer_money_to(amount, account)
    BankAccount.transaction do
      subtract(amount)
      account.add(amount)
    end
  end
end

# bank_account_spec.rb
describe "A money transfer" do
  before do
    @from_account = BankAccount.create(:amount => 100)
    @to_account   = BankAccount.create(:amount => 0)
  end
  it "should be atomic" do
    @to_account.stub!(:add).and_raise(AccountLockedException)
    @from_account.transfer_money_to(50, @to_account)
    @from_account.reload.amount.should eq(100)
  end
end

# --------------------------------------------------------------------------------------------------------
# TODO: folgende Szenarien aufzeigen [thorsten, 27.05.2008]
# wie teste ich zeitkritische Daten?
# wie teste ich eine externe Schnittstelle?
# wie teste ich XML-Output?

# folgende eventuell
# wie teste ich Performance?
# wie teste ich das Front-End?
# wie teste ich meine Internationalisierung?
# wie teste ich acts_as-Module?

# --------------------------------------------------------------------------------------------------------
# wie teste ich Caching?
# -> Fragment anlegen
describe HomeController, "fragment caching" do
  include CachingSpecHelper
  before do
    @key = {:action => 'index'}
  end

  it "should cache homepage" do
    get :index
    fragment(@key).should be_cached
  end
  it "should not cache homepage if user is logged in" do
    login(mock_user)
    get :index 
    fragment(@key).should_not be_cached
  end
end

# caching_spec_helper.rb
module CachingSpecHelper
  def fragment(key)
    returning(ensure_request{ @controller.read_fragment(key) }) do |frag|
      class << frag
        define_method(:cached?) { !blank? }
      end
    end
  end

  def create_fragment(key, content='dummy content')
    ensure_request { @controller.write_fragment(key, content) }
  end

  private
    def ensure_request
      return unless block_given?
      if @controller.request.nil?
        class << @controller
          define_method(:nothing) { render :nothing => true }
        end 
        get :nothing
      end
      yield
    end
end

# expire Fragment
describe UserController, "creating a user" do
  include CachingSpecHelper
  
  before do
    @key = {:action => 'index'}
  end
  
  it "should expire the homepage cache" do
    create_fragment(@key)
    post :create, :user => {:name => 'dude'} 
    fragment(@key).should_not be_cached
  end
end
