# Warum?
# - weil man sonst eventuell den gleichen Fehler wie in der Implementierung macht
# - Erwartungen lassen sich besser lesen

# nehmen wir mal folgende Implementierung
class Mailbox
  attr_accessor :messages_inbox, :messages_sent
  def messages
    messages_inbox + messages_sent
  end
end

# so nicht testen
describe "The number of messages a mailbox has altogether" do
  it "should be the sum of messages in the inbox and the messages sent" do
    mailbox = Mailbox.new(:messages_inbox => 2000, :messages_sent => 2)
    mailbox.messages.should eql(mailbox.messages_inbox + mailbox.messages_sent)
  end
end

# sondern so
describe "The number of messages a mailbox has altogether" do
  it "should be the sum of messages in the inbox and the messages sent" do
    mailbox = Mailbox.new(:messages_inbox => 2000, :messages_sent => 2)
    mailbox.messages.should eql(2002)
  end
end
