require 'spec_helper'

describe 'Cloudant::QueryBuilder' do
  before do
    @cloudant = Cloudant::Client.new({username: 'test', password: 'test', database: 'test'})
  end

  context 'permissions' do
    it 'should return permission information of the user currently logged in' do
      response = @cloudant.permissions
      expect(response).to eq({"ok"=>true, "info"=>{"authentication_db"=>"_users", "authentication_handlers"=>["cookie", "default"], "authenticated"=>"cookie"}, "userCtx"=>{"name"=>"test", "roles"=>["_admin", "_reader", "_writer"]}})
    end
  end

  context 'roles' do
    it 'should return permission information of the user currently logged in' do
      response = @cloudant.roles
      expect(response).to eq({"cloudant"=>{"test_user"=>["_reader"]}})
    end
  end

  context 'update_roles' do
    it 'should return permission information of the user currently logged in' do
      response = @cloudant.update_roles({"cloudant": {"new_user": ["_reader"]}})
      expect(response).to eq({"ok"=>true})
    end
  end

  context 'new_user' do
    it 'should return permission information of the user currently logged in' do
      response = @cloudant.new_user(["_reader"])
      expect(response).to eq({"password"=>"some_generated_password", "ok"=>true, "key"=>"some_generated_key", "roles"=>["_reader"]})
    end
  end

  context 'delete_user' do
    it 'should return permission information of the user currently logged in' do
      response = @cloudant.delete_user("test_user")
      expect(response).to eq({"ok"=>true})
    end
  end
  
  context 'check_roles' do
    it 'returns nil for nil' do
      roles = Cloudant::Security.check_roles(nil)
      expect(roles).to eq(nil)
    end
    
    it 'returns nil for empty array' do
      roles = Cloudant::Security.check_roles([])
      expect(roles).to eq(nil)
    end
    
    it 'returns nil for empty hash' do
      roles = Cloudant::Security.check_roles({})
      expect(roles).to eq(nil)
    end

    it 'returns nil for a string' do
      roles = Cloudant::Security.check_roles("")
      expect(roles).to eq(nil)
    end
    
    it 'returns nil for empty array' do
      roles = Cloudant::Security.check_roles(["_should_be_nil"])
      expect(roles).to eq(nil)
    end
    
    it 'returns _shards if shards' do
      roles = Cloudant::Security.check_roles(["_shards"])
      expect(roles).to eq(["_shards"])
    end

    it 'returns _db_updates if db_updates' do
      roles = Cloudant::Security.check_roles(["db_updates"])
      expect(roles).to eq(["_db_updates"])
    end
    
    it 'returns correct permissions if given symbol or string' do
      roles = Cloudant::Security.check_roles([:reader,"security"])
      expect(roles).to eq(["_reader", "_security"])
    end
    
    it 'ignores multiple incorrect args' do
      roles = Cloudant::Security.check_roles(["negative_test1","admin",:negative_test2])
      expect(roles).to eq(["_admin"])
    end

    it 'returns correct roles if all strings in array are incorrect' do
      roles = Cloudant::Security.check_roles(["negative_test1",:writer,"negative_test2"])
      expect(roles).to eq(["_writer"])
    end
  end
end