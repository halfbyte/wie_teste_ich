# - eigene Matcher und SharedSpecs

# Warum?
# - um sich nicht zu wiederholen (DRY) ;-)

# Probleme
# - ich kann keine Metaprogrammierung
#   -> braucht man ja gar nicht

# erstmal einen Shared-Spec

# logo_spec.rb
describe 'A logo' do
  before do
    @logo = Logo.new
  end
  it "should be valid with a valid content type" do
    ['image/gif', 'image/jpeg'].each do |content_type|
      @logo.content_type = content_type
      @logo.should be_valid
    end
  end
  it "should be invalid without a valid content type" do
    ['image/bmp','image/tif'].each do |content_type|
      @logo.content_type = content_type
      @logo.should_not be_valid
    end
  end
end

# besser:
# image_spec.rb
describe "a content type checker" do
  it "should be valid with a valid content type", :shared => true do
    ['image/gif', 'image/jpeg'].each do |content_type|
      @image.content_type = content_type
      @image.should be_valid
    end
  end
  it "should be invalid without a valid content type", :shared => true do
    ['image/bmp','image/tif'].each do |content_type|
      @image.content_type = content_type
      @image.should_not be_valid
    end
  end
end

# logo_spec.rb
describe 'A logo' do
  before do
    @image = Logo.new
  end
  it_should_behave_like 'a content type checker'
end


# --------------------------------------------------------------------------------------------------------
# Beispiel für eigenen Matcher
# user_spec.rb
describe "A user" do
  it "should have a name" do
    user = User.new(:name => nil)
    user.valid?
    user.errors_on(:name).to_a.should include("can't be blank")
  end
end

# have_validated_presence_of.rb
module ActiveRecordMatchers
  class HaveValidatedPresenceOf
    def initialize(field)
      @field=field
    end

    def matches?(model)
      @model = model.new
      @model.valid?
      @model.errors.on(@field)
      field_errors.each { |e| return true if e =~ /can't be blank/ }
      false
    end
    
    def description
      "have validate_presence_of #{@field}"
    end
    def failure_message
      "expected to validate presence_of #{@field}, but it doesn't"
    end
    def negative_failure_message
      "not expected to validate presence_of #{@field}, but it does"
    end
  end

  def have_validated_presence_of(field)
    HaveValidatedPresenceOf.new(field)
  end
end

# user_spec.rb
describe "A user" do
  it "should have a name" do
    User.should have_validated_presence_of(:name)
  end
end
