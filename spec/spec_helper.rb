$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'cloudant'
require 'webmock/rspec'
require 'coveralls'
Coveralls.wear!

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    username = "test"
    password = "test"
    base_url = "https://test.cloudant.com/"

    stub_request(:get, base_url).to_return(:status => 200, body: '{"couchdb":"Welcome","version":"1.0.2","cloudant_build":"2611"}', :headers => {})

    stub_request(:post, "https://test.cloudant.com/_session").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>"test.cloudant.com"},
           :body      => {"Accept"=>"*/*", "Content-Type"=>"application/x-www-form-urlencoded", "password"=>"test", "username"=>"test"}).
    to_return(:status => 200, :body => "{\"ok\":true}", :headers => {:x_couch_request_id=>"f35a80726e", :set_cookie=>["AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure"], :content_type=>"text/plain;charset=utf-8"})

    stub_request(:delete, "http://test.cloudant.com/_session").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"ok\":true}", :headers => {})

    stub_request(:put, "http://test.cloudant.com/test").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => '{"ok": true}', :headers => {})

    stub_request(:get, "http://test.cloudant.com/_all_dbs").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => '["test"]', :headers => {})

    stub_request(:delete, "http://test.cloudant.com/test").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => '{"ok": true}', :headers => {})

    stub_request(:get, "http://test.cloudant.com/test").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"update_seq\":\"1-g1AAAAI9eJyV0EsKwjAUBdD4Ad2FdQMlMW3TjOxONF9KqS1oHDjSnehOdCe6k5oQsNZBqZP3HiEcLrcEAMzziQSB5KLeq0zyJDTqYE4QJqEo66NklQkrZUr7c8wAXzRNU\",\"db_name\":\"test\",\"sizes\":{\"file\":180028,\"external\":1040,\"active\":3572},\"purge_seq\":0,\"other\":{\"data_size\":1040},\"doc_del_count\":4,\"doc_count\":3,\"disk_size\":140028,\"disk_format_version\":6,\"compact_running\":false,\"instance_start_time\":\"0\"}", :headers => {})

    stub_request(:post, "http://test.cloudant.com/test").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"_id\":\"4\",\"Content\":\"some content\"}").
    to_return(:status => 200, :body => "{\"ok\":true,\"id\":\"4\",\"rev\":\"1-be74a68c2105f3d9d0245eb8736ca9f1\"}", :headers => {})

    stub_request(:get, "http://test.cloudant.com/test/4").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"ok\":true,\"_id\":\"4\",\"rev\":\"1-be74a68c2105f3d9d0245eb8736ca9f1\", \"Content\":\"some content\"}", :headers => {})

    stub_request(:put, "http://test.cloudant.com/test/4").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"ok\":true,\"_id\":\"4\",\"rev\":\"1-be74a68c2105f3d9d0245eb8736ca9f1\",\"Content\":\"new content\"}").
    to_return(:status => 200, :body => "{\"ok\":true,\"id\":\"4\",\"rev\":\"2-9d1e36a820b5fc479c80a271643d5feb\"}", :headers => {})

    stub_request(:delete, "http://test.cloudant.com/test/4?rev=").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"ok\":true,\"id\":\"4\",\"rev\":\"3-2adb18cf3e094765b35df71e9a04c682\"}", :headers => {})

    stub_request(:get, "http://test.cloudant.com/test/_all_docs?include_docs=true").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"total_rows\":1,\"offset\":0,\"rows\":[{\"ok\":true,\"_id\":\"4\",\"rev\":\"1-be74a68c2105f3d9d0245eb8736ca9f1\",\"Content\":\"some content\"}]}", :headers => {})  

    stub_request(:get, "#{base_url}cloudant.com/test").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"update_seq\":\"1-g1AAAAI9eJyV0EsKwjAUBdD4Ad2FdQMlMW3TjOxONF9KqS1oHDjSnehOdCe6k5oQsNZBqZP3HiEcLrcEAMzziQSB5KLeq0zyJDTqYE4QJqEo66NklQkrZUr7c8wAXzRNU\",\"db_name\":\"test\",\"sizes\":{\"file\":180028,\"external\":1040,\"active\":3572},\"purge_seq\":0,\"other\":{\"data_size\":1040},\"doc_del_count\":4,\"doc_count\":3,\"disk_size\":140028,\"disk_format_version\":6,\"compact_running\":false,\"instance_start_time\":\"0\"}", :headers => {})

    stub_request(:get, "http://test.cloudant.com/test/_changes").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"results\":[{\"seq\":\"1-g1AAAAI9eJyV0EsKwjAUBdD4Ad2FdQMlMW3TjOxONF9KqS1oHDjSnehOdCe6k5oQsNZBqZP3HiEcLrcEAMzziQSB5KLeq0zyJDTqYE4QJqEo66NklQkrZUr7c8wAXzRNU-T22tmHGVMUapR2Bdwj8MBOvu4gscQyUtghyw-CYJ-SOWXTUSJMkKQ_UWgfsnXIuYOkhCCN6PBGqqmd4GKXda4OGvk0VCcCweHFeOjmoXubiEREIyb-KMdLDy89W4nTVGkqhhfkoZeHvkrimMJYrYo31bKsIg\",\"id\":\"foo\",\"changes\":[{\"rev\":\"1-967a00dff5e02add41819138abb3284d\"}]}],\"last_seq\":\"1-g1AAAAI9eJyV0EsKwjAUBdD4Ad2FdQMlMW3TjOxONF9KqS1oHDjSnehOdCe6k5oQsNZBqZP3HiEcLrcEAMzziQSB5KLeq0zyJDTqYE4QJqEo66NklQkrZUr7c8wAXzRNU-T22tmHGVMUapR2Bdwj8MBOvu4gscQyUtghyw-CYJ-SOWXTUSJMkKQ_UWgfsnXIuYOkhCCN6PBGqqmd4GKXda4OGvk0VCcCweHFeOjmoXubiEREIyb-KMdLDy89W4nTVGkqhhfkoZeHvkrimMJYrYo31bKsIg\",\"pending\":0}", :headers => {})

    stub_request(:post, "http://test.cloudant.com/test/_bulk_docs").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"docs\":[{\"_id\":\"4\",\"Content\":\"some content\"},{\"_id\":\"5\",\"Content\":\"more test content\"}]}").
    to_return(:status => 200, :body => "[{\"id\":\"4\",\"rev\":\"1-be74a68c2105f3d9d0245eb8736ca9f1\"},{\"id\":\"5\",\"rev\":\"1-be74a68c2105f3d9d0245eb8736ca9f1\"}]", :headers => {})

    stub_request(:post, "http://test.cloudant.com/test/_bulk_docs").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"docs\":[{\"_id\":\"4\",\"Content\":\"some new content\"},{\"_id\":\"5\",\"Content\":\"new test content\"}]}").
    to_return(:status => 200, :body => "[{\"id\":\"4\",\"rev\":\"2-9d1e36a820b5fc479c80a271643d5feb\"},{\"id\":\"5\",\"rev\":\"2-9d1e36a820b5fc479c80a271643d5feb\"}]", :headers => {})

    stub_request(:post, "http://test.cloudant.com/test/_bulk_docs").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"docs\":[{\"_id\":\"4\",\"Content\":\"some new content\",\"_deleted\":true},{\"_id\":\"5\",\"Content\":\"new test content\",\"_deleted\":true}]}").
    to_return(:status => 200, :body => "[{\"id\":\"4\",\"rev\":\"2-9d1e36a820b5fc479c80a271643d5feb\"},{\"id\":\"5\",\"rev\":\"2-9d1e36a820b5fc479c80a271643d5feb\"}]", :headers => {})

    stub_request(:post, "http://test.cloudant.com/test/_index").
      with(:headers     => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body        => "{\"index\":{},\"name\":\"test_index\",\"type\":\"text\"}").
      to_return(:status => 200, :body => '{"result": "created"}', :headers => {})

    stub_request(:get, "http://test.cloudant.com/test/_index").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"indexes\":[{\"ddoc\":null,\"name\":\"_all_docs\",\"type\":\"special\",\"def\":{\"fields\":[{\"_id\":\"asc\"}]}},{\"ddoc\":\"_design/32372935e14bed00cc6db4fc9efca0f1537d34a8\",\"name\":\"32372935e14bed00cc6db4fc9efca0f1537d34a8\",\"type\":\"text\",\"def\":{\"default_analyzer\":\"keyword\",\"default_field\":{},\"selector\":{},\"fields\":[],\"index_array_lengths\":true}}]}", :headers => {})

    stub_request(:delete, "http://test.cloudant.com/test/_index/_design/32372935e14bed00cc6db4fc9efca0f1537d34a8/text/32372935e14bed00cc6db4fc9efca0f1537d34a8").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"ok\":true}", :headers => {})

    stub_request(:put, "http://test.cloudant.com/test/_design/status").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"language\":\"javascript\"}").
    to_return(:status => 200, :body => "{\"ok\":true,\"id\":\"_design/status\",\"rev\":\"43-c072f33997085b5208ca0c28c2cfea24\"}", :headers => {})

    stub_request(:get, "http://test.cloudant.com/test/_design/status").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"_id\":\"_design/status\",\"_rev\":\"45-13153ec6708f15faa5818a285cda35c6\",\"language\":\"javascript\"}", :headers => {})

    stub_request(:put, "http://test.cloudant.com/test/_design/status").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"_id\":\"_design/status\",\"_rev\":\"45-13153ec6708f15faa5818a285cda35c6\",\"language\":\"javascript\"}").
    to_return(:status => 200, :body => "{\"ok\":true,\"id\":\"_design/status\",\"rev\":\"45-13153ec6708f15faa5818a285cda35c6\"}", :headers => {})

    stub_request(:put, "http://test.cloudant.com/test/_design/status").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"_id\":\"_design/status\",\"_rev\":\"45-13153ec6708f15faa5818a285cda35c6\",\"language\":\"javascript\",\"views\":{\"unstored\":{\"reduce\":\"_count\",\"map\":\"function (doc) {\\n  if (doc.status === \\\"new\\\") {\\n    emit(doc._id,1);\\n  }\\n}\"}}}").
    to_return(:status => 200, :body => "{\"ok\":true,\"id\":\"_design/status\",\"rev\":\"45-13153ec6708f15faa5818a285cda35c6\"}", :headers => {})

    stub_request(:put, "http://test.cloudant.com/test/_design/status").
      with(:body => "{\"views\":{},\"language\":\"javascript\"}",
           :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'}).
      to_return(:status => 200, :body => "{\"ok\":true,\"id\":\"_design/status\",\"rev\":\"45-13153ec6708f15faa5818a285cda35c6\"}", :headers => {})

    stub_request(:delete, "http://test.cloudant.com/test/_design/status?rev=45-13153ec6708f15faa5818a285cda35c6").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"_id\":\"_design/status\",\"_rev\":\"45-13153ec6708f15faa5818a285cda35c6\",\"language\":\"javascript\"}").
    to_return(:status => 200, :body => "{\"ok\":true,\"id\":\"_design/status\",\"rev\":\"46-c01fd54c2fd4823d64016e113ddef112\"}", :headers => {})

    stub_request(:post, "http://test.cloudant.com/test/_find").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"selector\":{\"test_field\":{\"$exists\":true}},\"fields\":[\"_id\",\"_rev\"],\"limit\":1,\"skip\":0}").
    to_return(:status => 200, :body => "{\"docs\":[],\"bookmark\":\"g2wAAAAOKCDavrUNZknSulczMbQ1tNBrdcIDPj1dZtpQIRlFBPAaT2XwBfQlrxokeHp0bAAAAAJuBAAAAACgbgQA____v2LCiAm_1qCeYAAAAGIAABVAag\"}", :headers => {})
    
    stub_request(:post, "http://test.cloudant.com/test/_find").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"selector\":{\"test_field\":{\"$exists\":false}},\"fields\":[\"_id\",\"_rev\"],\"limit\":1,\"skip\":0}").
    to_return(:status => 200, :body => "{\"docs\":[\"test\"],\"bookmark\":\"g2wAAAAOKCDavrUNZknSulczMbQ1tNBrdcIDPj1dZtpQIRlFBPAaT2XwBfQlrxokeHp0bAAAAAJuBAAAAACgbgQA____v2LCiAm_1qCeYAAAAGIAABVAag\"}", :headers => {})

    stub_request(:post, "http://test.cloudant.com/test/_find").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"selector\":{\"test_field\":{\"$exists\":false}},\"fields\":[\"_id\",\"_rev\"],\"limit\":1,\"skip\":0,\"bookmark\":\"g2wAAAAOKCDavrUNZknSulczMbQ1tNBrdcIDPj1dZtpQIRlFBPAaT2XwBfQlrxokeHp0bAAAAAJuBAAAAACgbgQA____v2LCiAm_1qCeYAAAAGIAABVAag\"}").
    to_return(:status => 200, :body => "{\"docs\":[],\"bookmark\":\"g2wAAAAOKCDavrUNZknSulczMbQ1tNBrdcIDPj1dZtpQIRlFBPAaT2XwBfQlrxokeHp0bAAAAAJuBAAAAACgbgQA____v2LCiAm_1qCeYAAAAGIAABVAag\"}", :headers => {})

    stub_request(:post, "http://test.cloudant.com/test/_find").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"selector\":{\"test_field\":{\"$existss\":true}},\"fields\":[\"_id\",\"_rev\"],\"limit\":1,\"skip\":0}").
    to_return(:status => 200, :body => "{\"error\":\"invalid_operator\",\"reason\":\"Invalid operator: $existss\"}", :headers => {})

    stub_request(:get, "http://test.cloudant.com/test/_design/status/_view/unstored?include_docs=true&reduce=false").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"total_rows\":2,\"offset\":0,\"rows\":[{\"id\":\"5d8e6c99198dfdde8accd8e019ba052\",\"key\":\"5d8e6c99198dfdde8accd8e019ba052\",\"value\":1,\"doc\":{\"_id\":\"5d8e6c99198dfdde8accd8e019ba052\",\"_rev\":\"1-7ebdb5b82e1cc4eaf2e27a711e9857c6\",\"a\":10,\"b\":92,\"c\":31}},{\"id\":\"5d8e6c99898dcdd08accd8e019badab\",\"key\":\"5d8e6c99898dcdd0daccd8e019badab\",\"value\":1,\"doc\":{\"_id\":\"5d8e6c99898dcdd8daccd8e019badab\",\"_rev\":\"1-d36298f4391da575df61e170af2efa34\",\"b\":12,\"c\":33}}]}", :headers => {})

    stub_request(:get, "http://test.cloudant.com/test/_design/status/_view/unstored").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"rows\":[{\"key\":null,\"value\":2}]}", :headers => {})

    stub_request(:get, "http://test.cloudant.com/_api/v2/db/test/_security").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"cloudant\":{\"test_user\":[\"_reader\"]}}", :headers => {})

    stub_request(:get, "http://test.cloudant.com/_session").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
    to_return(:status => 200, :body => "{\"ok\":true,\"info\":{\"authentication_db\":\"_users\",\"authentication_handlers\":[\"cookie\",\"default\"],\"authenticated\":\"cookie\"},\"userCtx\":{\"name\":\"test\",\"roles\":[\"_admin\",\"_reader\",\"_writer\"]}}", :headers => {})
    
    stub_request(:put, "http://test.cloudant.com/_api/v2/db/test/_security").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"cloudant\":{\"new_user\":[\"_reader\"]}}").
    to_return(:status => 200, :body => "{\"ok\":true}", :headers => {})

    stub_request(:post, "http://test.cloudant.com/_api/v2/api_keys").
      with(:headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body => "{\"Cookie\":\"AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure\"}").
      to_return(:status => 200, :body => "{\"password\":\"some_generated_password\",\"ok\":true,\"key\":\"some_generated_key\",\"roles\":[\"_reader\",\"_writer\"]}", :headers => {})

    stub_request(:put, "http://test.cloudant.com/_api/v2/db/test/_security").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"cloudant\":{\"some_generated_key\":[\"_reader\"}}").
    to_return(:status => 200, :body => "{\"ok\":true}", :headers => {})

    stub_request(:put, "http://test.cloudant.com/_api/v2/db/test/_security").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"cloudant\":{\"test_user\":[\"_reader\"],\"some_generated_key\":[\"_reader\"]}}").
    to_return(:status => 200, :body => "{\"password\":\"some_generated_password\",\"ok\":true,\"key\":\"some_generated_key\",\"roles\":[\"_reader\"]}", :headers => {})

    stub_request(:put, "http://test.cloudant.com/_api/v2/db/test/_security").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"cloudant\":{}}").
    to_return(:status => 200, :body => "{\"ok\":true}", :headers => {})

    stub_request(:get, "http://test.cloudant.com/_active_tasks").
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"type\":\"replication\"}").
    to_return(:status => 200, :body => "[]", :headers => {})

    stub_request(:put, /http:\/\/test.cloudant.com\/_replicator\/test_to_test_2_\d+{4}_\d+{2}_\d+{2}_\d+{2}_\d+{2}_\d+{2}/).
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"source\":\"https://test:test@test.cloudant.com/test\",\"target\":\"https://test:test@test.cloudant.com/test_2\",\"create_target\":true,\"continuous\":true}").
    to_return(:status => 200, :body => "{\"ok\":true,\"id\":\"replication-doc\",\"rev\":\"1-42a5c21c2b57130d7e7d20f7169rf6\"}", :headers => {})

    stub_request(:put, /http:\/\/test.cloudant.com\/_replicator\/test_to_test_2_\d+{4}_\d+{2}_\d+{2}_\d+{2}_\d+{2}_\d+{2}/).
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"source\":\"https://test:test@test.cloudant.com/test\",\"target\":\"https://test:test@test.cloudant.com/test_2\",\"create_target\":true,\"continuous\":false}").
    to_return(:status => 200, :body => "{\"ok\":true,\"id\":\"replication-doc\",\"rev\":\"1-42a5c21c2b57130d7e7d20f7169rf6\"}", :headers => {})

    stub_request(:put, /http:\/\/test.cloudant.com\/_replicator\/test_1_to_test_2_\d+{4}_\d+{2}_\d+{2}_\d+{2}_\d+{2}_\d+{2}/).
      with(:headers   => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'Cookie'=>'AuthSession=yWOGYbkliQXULjhSTrVgtue0HmAnoCfdJIEvMZxBKs1FDwzqRcpPaN_0eskojE; Version=1; Expires=Tue, 27-Sep-2016 06:35:33 GMT; Max-Age=86400; Path=/; HttpOnly; Secure'},
           :body      => "{\"source\":\"https://test:test@test.cloudant.com/test_1\",\"target\":\"https://test:test@test.cloudant.com/test_2\",\"create_target\":true,\"continuous\":true}").
    to_return(:status => 200, :body => "{\"ok\":true,\"id\":\"replication-doc\",\"rev\":\"1-42a5c21c2b57130d7e7d20f7169rf6\"}", :headers => {})
  end
end