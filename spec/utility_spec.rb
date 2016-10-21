describe 'Cloudant::Utility' do
  context 'generate_doc_name' do
    it 'should create the correct title for a replicated databse' do
      doc_name = Cloudant::Utility.generate_doc_name("test_1","test_2")
      time_now = Time.now.strftime('%F-%T').gsub(/(:|-)/,"_")
      time_str = "test_1_to_test_2_#{time_now}"

      expect(doc_name).to eq(time_str)
    end
  end
end