# Warum?
# - weil man die Tests sonst bei jeder kleinen Änderung anpassen muss
# - ausserdem sind die Tests im Fehlerfall besser zu lesen

# Probleme
# - ich laufe Gefahr zu wenig testen
#   -> das Problem hat man eigentlich immer beim Testen (Erfahrung hilft!)

# --------------------------------------------------------------------------------------------------------
# Beispiel: Mailertest
# user_mailer_spec.rb
describe UserMailer, "signup notification" do
  before do
    setup_mail_test
    @user = mock_user(:activation_code => 'abc')
  end
  it "should send a mail" do
    @expected.subject = "[TEMPODOME] Bitte aktiviere Deinen Account!"
    @expected.body    = read_mailers_fixture('user_mailer/signup_notification.txt')
    @expected.from    = "noreply@tempodome.com"
    @expected.to      = @user.email

    mail = UserMailer.create_signup_notification(@user)
    mail.should == @expected
  end
end

# signup_notification.txt
Hallo dude!

Wir freuen uns, Dich bei TEMPODOME begrüßen zu dürfen! 

Dein Benutzername ist: dude

Bevor es losgehen kann, musst Du Deine Anmeldung noch kurz per Klick auf den folgenden Link bestätigen. 

  http://test.com/activate/abc

Vielen Dank und viel Spaß auf TEMPODOME!
Dein TEMPODOME Team

# besser:
describe UserMailer, "signup notification" do
  ...
  it "should send a mail" do
    ...

    mail = UserMailer.create_signup_notification(@user)
    mail.should =~ /http:\/\/test\.com\/activate\/abc/
  end
end
