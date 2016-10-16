require 'spec_helper'

describe 'Cloudant', type: :model do
  before do
    @cloudant = Cloudant::Client.new({username: 'test', password: 'test', database: 'test'})
  end

  it 'has a version number' do
    expect(Cloudant::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(true).to eq(true)
  end

  context 'connection' do
    it 'should return a response' do
      response = Net::HTTP.get(URI("https://test.cloudant.com/"))
      expect(response).to be_a(String)
    end

    it 'should end a session' do
      response = @cloudant.close
      expect(response).to eq({"ok"=>true})
    end
  end

  context 'databases' do
    it 'should switch databases' do
      expect { @cloudant.database = 'changed' }.to change { @cloudant.database }.from('test').to('changed')
    end

    it 'should create a db and get a response of ok' do
      response = @cloudant.create_db('test')
      expect(response).to eq({"ok"=>true})
    end

    it 'should return an array of all dbs' do
      response = @cloudant.all_dbs
      expect(response).to eq(["test"])
    end

    it 'should delete a db and get a response of ok and the corresponding rev' do
      response = @cloudant.delete_db('test')
      expect(response).to eq({"ok"=>true})
    end

    it 'should get info for a db' do
      response = @cloudant.db_info
      expect(response).to eq({"update_seq"=>"1-g1AAAAI9eJyV0EsKwjAUBdD4Ad2FdQMlMW3TjOxONF9KqS1oHDjSnehOdCe6k5oQsNZBqZP3HiEcLrcEAMzziQSB5KLeq0zyJDTqYE4QJqEo66NklQkrZUr7c8wAXzRNU", "db_name"=>"test", "sizes"=>{"file"=>180028, "external"=>1040, "active"=>3572}, "purge_seq"=>0, "other"=>{"data_size"=>1040}, "doc_del_count"=>4, "doc_count"=>3, "disk_size"=>140028, "disk_format_version"=>6, "compact_running"=>false, "instance_start_time"=>"0"})
    end
  end

  context 'single document' do
    it 'should create a document and return its id, rev, and an ok status' do
      response = @cloudant.create_doc({"_id"=>"4", "Content" => "some content"})
      expect(response).to eq({"ok"=>true, "id"=>"4", "rev"=>"1-be74a68c2105f3d9d0245eb8736ca9f1"})
    end

    it 'should get a document based on db and id' do
      response = @cloudant.get_doc("4")
      expect(response).to eq({"ok"=>true, "_id"=>"4", "rev"=>"1-be74a68c2105f3d9d0245eb8736ca9f1", "Content"=>"some content"})
    end

    it 'should get all docs in a db' do
      response = @cloudant.all_docs({:include_docs => true})
      expect(response).to eq({"total_rows" => 1, "offset" => 0, "rows" => [{"ok"=>true, "_id"=>"4", "rev"=>"1-be74a68c2105f3d9d0245eb8736ca9f1", "Content"=>"some content"}]})
    end
  
    it 'should update a document' do
      response = @cloudant.update_doc({"ok"=>true, "_id"=>"4", "rev"=>"1-be74a68c2105f3d9d0245eb8736ca9f1", "Content"=>"new content"})
      expect(response).to eq({"ok"=>true, "id"=>"4", "rev"=>"2-9d1e36a820b5fc479c80a271643d5feb"})
    end

    it 'should get all_changes from a document' do
      response = @cloudant.changes
      expect(response).to eq({"results" => [{"seq" => "1-g1AAAAI9eJyV0EsKwjAUBdD4Ad2FdQMlMW3TjOxONF9KqS1oHDjSnehOdCe6k5oQsNZBqZP3HiEcLrcEAMzziQSB5KLeq0zyJDTqYE4QJqEo66NklQkrZUr7c8wAXzRNU-T22tmHGVMUapR2Bdwj8MBOvu4gscQyUtghyw-CYJ-SOWXTUSJMkKQ_UWgfsnXIuYOkhCCN6PBGqqmd4GKXda4OGvk0VCcCweHFeOjmoXubiEREIyb-KMdLDy89W4nTVGkqhhfkoZeHvkrimMJYrYo31bKsIg", "id" => "foo", "changes" => [{"rev" => "1-967a00dff5e02add41819138abb3284d"}]}],"last_seq" => "1-g1AAAAI9eJyV0EsKwjAUBdD4Ad2FdQMlMW3TjOxONF9KqS1oHDjSnehOdCe6k5oQsNZBqZP3HiEcLrcEAMzziQSB5KLeq0zyJDTqYE4QJqEo66NklQkrZUr7c8wAXzRNU-T22tmHGVMUapR2Bdwj8MBOvu4gscQyUtghyw-CYJ-SOWXTUSJMkKQ_UWgfsnXIuYOkhCCN6PBGqqmd4GKXda4OGvk0VCcCweHFeOjmoXubiEREIyb-KMdLDy89W4nTVGkqhhfkoZeHvkrimMJYrYo31bKsIg","pending" => 0})
    end

    it 'should delete a document and return ok and its rev' do
      response = @cloudant.delete_doc("4")
      expect(response).to eq({"ok"=>true, "id"=>"4", "rev"=>"3-2adb18cf3e094765b35df71e9a04c682"})
    end
  end

  context 'multiple documents' do
    it 'should allow multiple docs to be created' do
      response = @cloudant.create_docs([{"_id"=>"4", "Content" => "some content"}, {"_id"=>"5", "Content" => "more test content"}])
      expect(response).to eq([{"id"=>"4", "rev"=>"1-be74a68c2105f3d9d0245eb8736ca9f1"}, {"id"=>"5", "rev"=>"1-be74a68c2105f3d9d0245eb8736ca9f1"}])
    end

    it 'should allow multiple docs to be updated' do
      response = @cloudant.update_docs([{"_id"=>"4", "Content" => "some new content"}, {"_id"=>"5", "Content" => "new test content"}])
      expect(response).to eq([{"id"=>"4", "rev"=>"2-9d1e36a820b5fc479c80a271643d5feb"}, {"id"=>"5", "rev"=>"2-9d1e36a820b5fc479c80a271643d5feb"}])
    end

    it 'should allow multiple docs to be deleted' do
      response = @cloudant.delete_docs([{"_id"=>"4", "Content" => "some new content"}, {"_id"=>"5", "Content" => "new test content"}])
      expect(response).to eq([{"id"=>"4", "rev"=>"2-9d1e36a820b5fc479c80a271643d5feb"}, {"id"=>"5", "rev"=>"2-9d1e36a820b5fc479c80a271643d5feb"}])
    end
  end

  context 'indices' do
    it 'should create a query index' do
      response = @cloudant.create_index({index: {}, type: "text", name: "test_index"})
      expect(response).to eq({"result"=>"created"})
    end

    it 'should create a query index' do
      expect{ @cloudant.create_index({}) }.to raise_error(ArgumentError)
    end

    it 'should get all of the indices for a database' do
      response = @cloudant.get_indices
      expect(response).to eq({"indexes" => [{"ddoc"=>nil, "name"=>"_all_docs", "type"=>"special", "def"=>{"fields"=>[{"_id"=>"asc"}]}}, {"ddoc"=>"_design/32372935e14bed00cc6db4fc9efca0f1537d34a8", "name"=>"32372935e14bed00cc6db4fc9efca0f1537d34a8", "type"=>"text", "def"=>{"default_analyzer"=>"keyword", "default_field"=>{}, "selector"=>{}, "fields"=>[], "index_array_lengths"=>true}}]})
    end

    it 'should get all of the indices for a database (alias get_indexes)' do
      response = @cloudant.get_indexes
      expect(response).to eq({"indexes"=>[{"ddoc"=>nil, "name"=>"_all_docs", "type"=>"special", "def"=>{"fields"=>[{"_id"=>"asc"}]}}, {"ddoc"=>"_design/32372935e14bed00cc6db4fc9efca0f1537d34a8", "name"=>"32372935e14bed00cc6db4fc9efca0f1537d34a8", "type"=>"text", "def"=>{"default_analyzer"=>"keyword", "default_field"=>{}, "selector"=>{}, "fields"=>[], "index_array_lengths"=>true}}]})
    end

    it 'should delete a query index' do
      response = @cloudant.delete_index({ddoc: "_design/32372935e14bed00cc6db4fc9efca0f1537d34a8", type: "text", name: "32372935e14bed00cc6db4fc9efca0f1537d34a8"})
      expect(response).to eq({"ok" => true})
    end
  end

  context 'design docs' do
    it 'should create a design doc' do
      response = @cloudant.create_design_doc('status',{'language' => 'javascript'})
      expect(response).to eq({"ok"=>true, "id"=>"_design/status", "rev"=>"43-c072f33997085b5208ca0c28c2cfea24"})
    end

    it 'should update a design doc' do
      response = @cloudant.update_design_doc('status',{'views' => {}, 'language' => 'javascript'})
      expect(response).to eq({"ok"=>true, "id"=>"_design/status", "rev"=>"45-13153ec6708f15faa5818a285cda35c6"})
    end
    
    it 'should get an existing design doc' do
      response = @cloudant.get_design_doc('status')
      expect(response).to eq({"_id"=>"_design/status", "_rev"=>"45-13153ec6708f15faa5818a285cda35c6", "language"=>"javascript"})
    end

    it 'should delete a design doc' do
      response = @cloudant.delete_design_doc('status')
      expect(response).to eq({"ok"=>true, "id"=>"_design/status", "rev"=>"46-c01fd54c2fd4823d64016e113ddef112"})
    end
  end

  context 'query selectors' do
    it 'should send a single query and return the correct document or documents' do
      response = @cloudant.query({"selector" => {"test_field" => {"$exists" => true}},"fields" => ["_id", "_rev"],"limit" => 1,"skip" => 0})
      expect(response).to eq({"docs"=>[],"bookmark"=>"g2wAAAAOKCDavrUNZknSulczMbQ1tNBrdcIDPj1dZtpQIRlFBPAaT2XwBfQlrxokeHp0bAAAAAJuBAAAAACgbgQA____v2LCiAm_1qCeYAAAAGIAABVAag"})
    end

    it 'should return an error hash if an invalid query selector is sent' do
      response = @cloudant.query({"selector" => {"test_field" => {"$existss" => true}},"fields" => ["_id", "_rev"],"limit" => 1,"skip" => 0})
      expect(response).to eq({"error"=>"invalid_operator", "reason"=>"Invalid operator: $existss"})
    end

    it 'should perform paginated queries by passing a bookmark while querying' do
      response = @cloudant.bookmark_query({"selector" => {"test_field" => {"$exists" => false}},"fields" => ["_id", "_rev"],"limit" => 1,"skip" => 0}) { |docs| docs }
      expect(response).to eq([])
    end
  end

  context 'views' do
    it 'should create a view' do
      response = @cloudant.create_view('status',{"unstored"=>{"reduce"=>"_count","map"=>"function (doc) {\n  if (doc.status === \"new\") {\n    emit(doc._id,1);\n  }\n}"}})
      expect(response).to eq({"ok"=>true, "id"=>"_design/status", "rev"=>"45-13153ec6708f15faa5818a285cda35c6"})
    end

    it 'should query an existing view' do
      response = @cloudant.view('status','unstored')
      expect(response).to eq({"rows"=>[{"key"=>nil, "value"=>2}]})
    end

    it 'should query an existing view with options' do
      response = @cloudant.view('status','unstored', :reduce => false, :include_docs => true)
      expect(response).to eq({"total_rows"=>2, "offset"=>0, "rows"=>[{"id"=>"5d8e6c99198dfdde8accd8e019ba052", "key"=>"5d8e6c99198dfdde8accd8e019ba052", "value"=>1, "doc"=>{"_id"=>"5d8e6c99198dfdde8accd8e019ba052", "_rev"=>"1-7ebdb5b82e1cc4eaf2e27a711e9857c6", "a"=>10, "b"=>92, "c"=>31}}, {"id"=>"5d8e6c99898dcdd08accd8e019badab", "key"=>"5d8e6c99898dcdd0daccd8e019badab", "value"=>1, "doc"=>{"_id"=>"5d8e6c99898dcdd8daccd8e019badab", "_rev"=>"1-d36298f4391da575df61e170af2efa34", "b"=>12, "c"=>33}}]})
    end
  end
end