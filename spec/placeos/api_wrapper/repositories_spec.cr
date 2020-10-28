require "../../spec_helper"

# require "placeos-models"

module PlaceOS
  describe Client::APIWrapper::Repositories do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Repositories.new api

    repositories_json = <<-JSON
    [
      {
        "id": "repository-oOj2lGgsz",
        "name": "Place",
        "uri": "uri",
        "repo_name": "your-fave-repo",
        "username": "GabFitzgerald",
        "password": "iheartadamlambert",
        "key": "sshhhshsh",
        "foldername": "your-fave-folder",
        "description": "description-woo",
        "commit-hash": "b930e07d9fd2b682de48e881d5405176888a1de8",
        "branch": "master",
        "repo_type": "Driver"
      }
    ]
    JSON

    repositories = Array(JSON::Any).from_json(repositories_json).map &.to_json

    describe "#search" do
      it "enumerates all repositories" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: repositories_json)
        result = client.search
        result.size.should eq(1)
        result.first.should be_a(Client::API::Models::Repository)
        result.first.name.should eq("Place")
      end

      it "provides repositories search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"q" => "Place", "limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: repositories_json)
        result = client.search q: "Place"
        result.size.should eq(1)
        result.first.name.should eq("Place")
      end
    end

    it "#fetch" do
      WebMock
        .stub(:get, DOMAIN + "#{client.base}/repository-oOj2lGgsz")
        .to_return(body: repositories.first)
      result = client.fetch "repository-oOj2lGgsz"
      result.should be_a(Client::API::Models::Repository)
      result.to_json.should eq("{\"id\":\"repository-oOj2lGgsz\",\"name\":\"Place\",\"uri\":\"uri\",\"repo_type\":0,\"username\":\"GabFitzgerald\",\"password\":\"iheartadamlambert\",\"key\":\"sshhhshsh\",\"description\":\"description-woo\",\"branch\":\"master\"}")
    end

    it "#destroy" do
      WebMock
        .stub(:delete, DOMAIN + "#{client.base}/repository-oOj2lGgsz")
      result = client.destroy "repository-oOj2lGgsz"
      result.should be_nil
    end

    describe "#create" do
      body = {name: "Place", uri: "uri", repo_type: "FIX THIS", username: "GabFitzgerald", password: "iheartadamlambert", key: "sshhhshsh", folder_name: "your-fave-folder", description: "description description", commit_hash: "b930e07d9fd2b682de48e881d5405176888a1de7"}.to_json
      WebMock
        .stub(:post, DOMAIN + client.base)
        .with(
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: body
        )
        .to_return(body: repositories.last)
      result = client.create(name: "Place", uri: "uri", repo_type: "FIX THIS", username: "GabFitzgerald", password: "iheartadamlambert", key: "sshhhshsh", folder_name: "your-fave-folder", description: "description description", commit_hash: "b930e07d9fd2b682de48e881d5405176888a1de7")
      result.should be_a(Client::API::Models::Repository)
      result.to_json.should eq("{\"id\":\"repository-oOj2lGgsz\",\"name\":\"Place\",\"uri\":\"uri\",\"repo_type\":0,\"username\":\"GabFitzgerald\",\"password\":\"iheartadamlambert\",\"key\":\"sshhhshsh\",\"description\":\"description-woo\",\"branch\":\"master\"}")
    end

    it "#update" do
      WebMock
        .stub(:put, DOMAIN + "#{client.base}/repository-oOj2lGgsz")
        .with(
          headers: {"Content-Type" => "application/json"},
          body: {username: "GabFitzgerald", password: "asdfgh", key: "key", name: "Foo", uri: "uri", repo_type: "Driver", folder_name: "folder", description: "new description", commit_hash: "b930e07d9fd2b682de48e881d5405176888a1de6"}.to_json
        )
        .to_return(body: repositories.first)
      result = client.update id: "repository-oOj2lGgsz", username: "GabFitzgerald", password: "asdfgh", key: "key", name: "Foo", uri: "uri", repo_type: "Driver", folder_name: "folder", description: "new description", commit_hash: "b930e07d9fd2b682de48e881d5405176888a1de6"
      result.should be_a(Client::API::Models::Repository)
      result.to_json.should eq("{\"id\":\"repository-oOj2lGgsz\",\"name\":\"Place\",\"uri\":\"uri\",\"repo_type\":0,\"username\":\"GabFitzgerald\",\"password\":\"iheartadamlambert\",\"key\":\"sshhhshsh\",\"description\":\"description-woo\",\"branch\":\"master\"}")
    end

    it "#pull" do
      # body = {name: "Place", uri: "uri", repo_type: "FIX THIS", username: "GabFitzgerald", password: "iheartadamlambert", key: "sshhhshsh", folder_name: "your-fave-folder", description: "description description", commit_hash: "b930e07d9fd2b682de48e881d5405176888a1de7"}.to_json
      # WebMock
      #   .stub(:post, DOMAIN + "#{client.base}/repository-oOj2lGgsz/pull")
      #   .with(
      #     # headers: {"Content-Type" => "application/json"}
      #     # body: body
      #   )
      #   .to_return(body: repositories.first)
      # result = client.pull id: "repository-oOj2lGgsz"
      # result.should be_a(Client::API::Models::Repository)
      # # result.to_json.should eq("{\"id\":\"repository-oOj2lGgsz\",\"name\":\"Place\",\"uri\":\"uri\",\"repo_type\":0,\"username\":\"GabFitzgerald\",\"password\":\"iheartadamlambert\",\"key\":\"sshhhshsh\",\"description\":\"description-woo\",\"branch\":\"master\"}")
    end

    describe "#loaded_interfaces" do
    end

    describe "#drivers" do
    end

    describe "#commits" do
    end

    describe "#details" do
    end

    it "#branches" do
      # WebMock
      #   .stub(:get, DOMAIN + "#{client.base}/repository-oOj2lGgsz/branches")
      #   .to_return(body: "")
      # result = client.fetch "repository-oOj2lGgsz"
      # result.should be_a(Client::API::Models::Repository)
      # result.to_json.should eq("{\"id\":\"repository-oOj2lGgsz\",\"name\":\"Place\",\"uri\":\"uri\",\"repo_type\":0,\"username\":\"GabFitzgerald\",\"password\":\"iheartadamlambert\",\"key\":\"sshhhshsh\",\"description\":\"description-woo\",\"branch\":\"master\"}")

    end
  end
end
