require 'spec_helper'

describe 'Cloudant::Attachment' do
  before do
    @cloudant = Cloudant::Client.new({username: 'test', password: 'test', database: 'test'})
  end

  it 'should detect the module' do
    expect(Cloudant::VERSION).not_to be nil
  end
end