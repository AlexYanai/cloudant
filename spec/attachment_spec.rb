require 'spec_helper'

describe 'Cloudant::Attachment' do
  before do
    @cloudant = Cloudant::Client.new({username: 'test', password: 'test', database: 'test'})
  end

  context '#create_attachment' do
    it 'should create an attachment for document' do
      doc_params = {
        :id   => "test_doc",
        :name => "test_attachment",
        :type => "text/html",
        :rev  => "1-f53050cbc4e66a4dcf6db59a9e0bc6b",
        :path => "./spec/assets/test.html"
      }

      result = {
        "id"  => "test_doc",
        "ok"  => true,
        "rev" => "2-147bc19a1bfd9bfdaf5ee6e2e05be74"
      }
      
      response = @cloudant.create_attachment(doc_params)
      expect(response).to eq(result)
    end

    it 'should create an attachment for a document and get the doc rev if not given' do
      doc_params = {
        :id   => "test_doc",
        :name => "test_attachment",
        :type => "text/html",
        :path => "./spec/assets/test.html"
      }

      result = {
        "id"  => "test_doc",
        "ok"  => true,
        "rev" => "2-147bc19a1bfd9bfdaf5ee6e2e05be74"
      }
      
      response = @cloudant.create_attachment(doc_params)
      expect(response).to eq(result)
    end
  end

  context '#read_attachment' do
    it 'should retrieve an attachment' do
      doc_params = {
        :id   => "test_doc",
        :name => "test_attachment"
      }

      result = {
        "_id" => "test_doc", 
        "_attachments" => {"test_attachment"=>{"content_type"=>"text/html", "data"=>"<html>\n  <head>\n    <h1>Test Doc</h1>\n  </head>\n  <body>\n    <p>Test Content</p>\n  </body>\n</html>"}}
      }
      
      response = @cloudant.read_attachment(doc_params)
      expect(response).to eq(result)
    end
  end

  context '#delete_attachment' do
    it 'should delete an attachment' do
      doc_params = {
        :id   => "test_doc",
        :name => "test_attachment",
        :rev => "3-292b06ac095434c81174d7bae5c5d4e"
      }

      result = {
        "ok"=>true,
        "id"=>"test_doc",
        "rev"=>"3-292b06ac095434c81174d7bae5c5d4e"
      }
      
      response = @cloudant.delete_attachment(doc_params)
      expect(response).to eq(result)
    end
  end

  context '#make_attachment' do
    it 'should detect the module' do
      doc_params = {
        :id   => "test_doc",
        :name => "test_attachment",
        :type => "text/html",
        :path => "./spec/assets/test.html"
      }

      test_attachment = {
        "_id" => "test_doc",
        "_attachments" => {
          "test_attachment" => {
            "content_type" => "text/html",
            "data" => "<html>\n  <head>\n    <h1>Test Doc</h1>\n  </head>\n  <body>\n    <p>Test Content</p>\n  </body>\n</html>"
          }
        }
      }

      attachment = Cloudant::Attachment.make_attachment(doc_params)
      expect(attachment).to eq(test_attachment)
    end

    it 'should raise an Errno::ENOENT if the file does not exist' do
      doc_params = {
        :id   => "test_doc",
        :name => "test_attachment",
        :type => "text/html",
        :path => "./spec/test.html"
      }

      expect{ Cloudant::Attachment.make_attachment(doc_params) }.to raise_error(Errno::ENOENT)
    end
  end
end