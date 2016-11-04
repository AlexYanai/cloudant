require 'spec_helper'

describe 'Cloudant::Attachment' do
  before do
    @cloudant = Cloudant::Client.new({username: 'test', password: 'test', database: 'test'})
  end

  it 'should detect the module' do
    doc_params = {
      :doc => "test_doc",
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

    attachment = Cloudant::Attachment.create_attachment(doc_params)
    expect(attachment).to eq(test_attachment)
  end
end