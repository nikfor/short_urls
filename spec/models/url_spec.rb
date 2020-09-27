require 'rails_helper'

RSpec.describe Url, type: :model do
  let(:url) { create(:url) }
	let(:invalid_url) { build(:url, original_url: 'www.test.test/  /sdsd') }

  it { should validate_presence_of :original_url }

  it 'doesnt create url with invalid format' do
  	expect(invalid_url.valid?).to be_falsey
  	expect(invalid_url.errors.full_messages).to include('Original url is invalid')
  end

  it 'set short url when record create' do
  	url = Url.create(original_url: 'https://www.test.test/abcd?a=1')
    
    expect(url.short_url).not_to be_empty
    expect(url.short_url.size).to eq(8)
  end

  it 'increment counter' do
    url.increment_counter!
    expect(url.counter).to eq(1)

    url.increment_counter!
    expect(url.counter).to eq(2)
  end
end
