require 'spec_helper'

describe 'Cloudant::Replicator' do
  before do
    @cloudant = Cloudant::Client.new({username: 'test', password: 'test', database: 'test'})
  end

  context 'active_tasks' do
    it 'returns active data replication tasks' do
      response = @cloudant.active_tasks
      expect(response).to eq([])
    end
  end
end