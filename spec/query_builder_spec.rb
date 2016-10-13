require 'spec_helper'

describe 'Cloudant::QueryBuilder' do
  context 'views' do
    it 'should return an empty string if no options are given' do
      q = Cloudant::QueryBuilder.build({},"view")
      expect(q).to eq("")
    end

    it 'should return the correct query string for a set of options' do
      q = Cloudant::QueryBuilder.build({:include_docs => true, :descending => true, :group => true},"view")
      expect(q).to eq("?include_docs=true&descending=true&group=true")
    end

    it 'should return the correct query string for a set of options' do
      q = Cloudant::QueryBuilder.build({:include_docs => true, :test => true, :group => true},"view")
      expect(q).to eq("?include_docs=true&group=true")
    end
  end
end