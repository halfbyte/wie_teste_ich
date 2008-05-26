# - eine Assertion pro Test?

# Warum?
# - lesbarer
# - man konzentriert sich eher auf das was man testen möchte (ausgedrückt im it-Text)
# -> an dieser Stelle kann man gut gute und schlechte Art zeigen und damit vergleichen!

  # so nicht!
  describe User, "roles" do
    it "should allow band" do
      @user = build_user(:role => nil)
      @user.should_not be_band
      @user.role = 'user'
      @user.should_not be_band
      @user.role = 'band'
      @user.should be_band
      @user.role = 'admin'
      @user.should_not be_band
    end
  end

# Problem
# - Aufbau des Tests (via before) dauert lange
#   -> vielleicht ist der Code noch nicht gut designt?

  # so nicht!
  describe User, 'upcoming concerts' do
    before do
      event = create_event
      deleted_event = create_event(:user => event.user, :deleted_at => Time.now)
      create_concert(:event => event, :user => event.user, :started_at => 2.days.from_now)
      create_concert(:event => deleted_event, :user => event.user, :started_at => 2.days.from_now)
      create_concert(:event => event, :user => event.user, :started_at => 2.days.from_now, :state => 'cancelled')
      create_concert(:event => event, :user => event.user, :started_at => 2.days.ago)

      @voter = create_user(:login => 'voter')
      create_vote(:event => event, :user => @voter)
      create_vote(:event => deleted_event, :user => @voter)
    end
    it "should deliver concerts" do
      @voter.upcoming_concerts.size.should_not eql(0)
    end
    it "should deliver only concerts in the future" do
      @voter.upcoming_concerts.each {|concert| concert.should be_active_concert}
    end
    it "should deliver concerts ordered by start date" do
      @voter.upcoming_concerts.each_cons(2) do |cons|
        (cons[0].started_at <= cons[1].started_at).should be_true
      end
    end
  end
  
