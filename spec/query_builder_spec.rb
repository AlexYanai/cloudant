require 'spec_helper'

describe 'Cloudant::QueryBuilder' do
  before do
    @cloudant = Cloudant::Client.new({username: 'test', password: 'test', database: 'test'})
  end

  it 'should return an empty string if no options are given' do
    q = @cloudant.build_query_string({},"view")
    expect(q).to eq("")
  end

  context 'views' do
    it 'views should return the correct query string for a set of options' do
      q = @cloudant.build_query_string({:include_docs => true, :descending => true, :group => true},"view")
      expect(q).to eq("?include_docs=true&descending=true&group=true")
    end

    it 'views should return the correct query string for a set of options' do
      q = @cloudant.build_query_string({:include_docs => true, :test => true, :group => true},"view")
      expect(q).to eq("?include_docs=true&group=true")
    end
  end

  context 'all_docs' do
    it 'all_docs should return the correct query string for a set of options' do
      q = @cloudant.build_query_string({:include_docs => true, :skip => true},"all_docs")
      expect(q).to eq("?include_docs=true&skip=true")
    end

    it 'all_docs should return the correct query string for a set of options' do
      q = @cloudant.build_query_string({:include_docs => true, :skip => true, :keys => ["first","second"]},"all_docs")
      expect(q).to eq("?include_docs=true&skip=true&keys=[\"first\", \"second\"]")
    end
  end

  context 'changes' do
    it 'changes should return the correct query string for a set of options' do
      q = @cloudant.build_query_string({:include_docs => true, :filter => true},"changes")
      expect(q).to eq("?include_docs=true&filter=true")
    end
  end

  context 'doc' do
    it 'doc should return the correct query string for a set of options' do
      q = @cloudant.build_query_string({:local_seq => true, :latest => true},"doc")
      expect(q).to eq("?local_seq=true&latest=true")
    end
  end
end