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

  context 'replicate_db and replicate_dbs' do
    it 'should attempt to PUT to _replicator and return an id when created' do
      response = @cloudant.replicate_db("test_2")
      expect(response).to eq({"ok"=>true, "id"=>"replication-doc", "rev"=>"1-42a5c21c2b57130d7e7d20f7169rf6"})
    end

    it 'should attempt to PUT to continuously _replicator and return an id when created' do
      response = @cloudant.replicate_db("test_2", :continuous => true)
      expect(response).to eq({"ok"=>true, "id"=>"replication-doc", "rev"=>"1-42a5c21c2b57130d7e7d20f7169rf6"})
    end

    it 'should attempt to PUT to continuously _replicator and return an id when created' do
      response = @cloudant.replicate_dbs("test_1", "test_2", :continuous => true)
      expect(response).to eq({"ok"=>true, "id"=>"replication-doc", "rev"=>"1-42a5c21c2b57130d7e7d20f7169rf6"})
    end
  end

  context 'sync' do
    it 'returns active data replication tasks' do
      response = @cloudant.sync("test_2")
      expect(response).to eq({"ok"=>true, "id"=>"replication-doc", "rev"=>"1-42a5c21c2b57130d7e7d20f7169rf6"})
    end
  end

  context 'build_doc' do
    it 'should create the right replication document' do
      doc = {
        :source => "https://test:test@test.cloudant.com/test",
        :target => "https://test:test@test.cloudant.com/replicated",
        :create_target => true,
        :continuous => false
      } 
      response = @cloudant.build_doc({:source => "test", :target => "replicated"})
      expect(response).to eq(doc)
    end

    it 'should attempt to PUT to continuously _replicator and return an id when created' do
      doc = {
        :source => "https://test:test@test.cloudant.com/test",
        :target => "https://test:test@test.cloudant.com/replicated",
        :create_target => false,
        :continuous => true
      } 

      response = @cloudant.build_doc({:source => "test", :target => "replicated", :continuous => true, :create_target => false})
      expect(response).to eq(doc)
    end

    it 'should attempt to PUT to continuously _replicator and return an id when created' do
      doc = {
        :source => "https://test:test@test.cloudant.com/test",
        :target => "https://test:test@test.cloudant.com/replicated",
        :create_target => true,
        :continuous => false,
        :user_ctx => {"name" => "test_user", "roles" => ["admin"]}
      } 

      response = @cloudant.build_doc({:source => "test", :target => "replicated", :continuous => false, :create_target => true, :user_ctx => {"name" => "test_user", "roles" => ["admin"]}})
      expect(response).to eq(doc)
    end
  end
end