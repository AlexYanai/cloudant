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

  context 'replicate_db' do
    it 'should attempt to PUT to _replicator and return an id when created' do
      response = @cloudant.replicate_db("test_2")
      expect(response).to eq({"ok"=>true, "id"=>"replication-doc", "rev"=>"1-42a5c21c2b57130d7e7d20f7169rf6"})
    end
  end
end