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
        result.first.should be_a(PlaceOS::Model::Repository)
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
      result.should be_a(PlaceOS::Model::Repository)
      # result.to_json.should eq("{\"created_at\":1603946666,\"updated_at\":1603946666,\"name\":\"Place\",\"description\":\"description-woo\",\"uri\":\"uri\",\"commit_hash\":\"HEAD\",\"branch\":\"master\",\"repo_type\":\"Driver\",\"username\":\"GabFitzgerald\",\"password\":\"iheartadamlambert\",\"key\":\"sshhhshsh\"}")
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
      result.should be_a(PlaceOS::Model::Repository)
      # result.to_json.should eq("{\"id\":\"repository-oOj2lGgsz\",\"name\":\"Place\",\"uri\":\"uri\",\"repo_type\":0,\"username\":\"GabFitzgerald\",\"password\":\"iheartadamlambert\",\"key\":\"sshhhshsh\",\"description\":\"description-woo\",\"branch\":\"master\"}")
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
      result.should be_a(PlaceOS::Model::Repository)
      # result.to_json.should eq("{\"id\":\"repository-oOj2lGgsz\",\"name\":\"Place\",\"uri\":\"uri\",\"repo_type\":0,\"username\":\"GabFitzgerald\",\"password\":\"iheartadamlambert\",\"key\":\"sshhhshsh\",\"description\":\"description-woo\",\"branch\":\"master\"}")
    end

    it "#pull" do
      WebMock
        .stub(:post, DOMAIN + "#{client.base}/repo-G03MS-DUJCo/pull")
        .to_return(body: %({"commit_hash":"1e2296c"}))

      result = client.pull id: "repo-G03MS-DUJCo"
      result.should be_a(NamedTuple(commit_hash: String))
      result.should eq({commit_hash: "1e2296c"})
    end

    describe "#loaded_interfaces" do
    end

    describe "#drivers" do
      WebMock
        .stub(:get, DOMAIN + "#{client.base}/repo-G03MS-DUJCo/drivers")
        .to_return(body: %(["drivers/place/private_helper.cr", "drivers/place/feature_test.cr"]))

      result = client.drivers id: "repo-G03MS-DUJCo"
      result.should be_a(Array(Path))
      result.should eq([Path["drivers/place/private_helper.cr"], Path["drivers/place/feature_test.cr"]])
    end

    describe "#commits" do
      WebMock
        .stub(:get, DOMAIN + "#{client.base}/repo-G03MS-DUJCo/commits")
        .with(query: {"driver" => "drivers/place/private_helper.cr"})
        .to_return(body: %([{"commit":"1b2de89","date":"2020-05-08T16:06:14+10:00","author":"Caspian Baska","subject":"refactor: migrate to Log"},{"commit":"2ee7ab1","date":"2020-04-08T14:08:20+10:00","author":"Stephen von Takach","subject":"feat: add feature test driver"},{"commit":"4be0571","date":"2020-03-12T13:03:00+11:00","author":"Caspian Baska","subject":"feat(place:private_helper): add an echo function"},{"commit":"ca54d2e","date":"2020-03-09T16:04:49+11:00","author":"Caspian Baska","subject":"refactor: `ACAEngine` -> `PlaceOS`"}]))

      result = client.commits id: "repo-G03MS-DUJCo", driver: "drivers/place/private_helper.cr"
      result.should be_a(Array(NamedTuple(commit: String, date: Time, author: String, subject: String)))
      result.should eq(Array(NamedTuple(commit: String, date: Time, author: String, subject: String)).from_json(%([{"commit":"1b2de89","date":"2020-05-08T16:06:14+10:00","author":"Caspian Baska","subject":"refactor: migrate to Log"},{"commit":"2ee7ab1","date":"2020-04-08T14:08:20+10:00","author":"Stephen von Takach","subject":"feat: add feature test driver"},{"commit":"4be0571","date":"2020-03-12T13:03:00+11:00","author":"Caspian Baska","subject":"feat(place:private_helper): add an echo function"},{"commit":"ca54d2e","date":"2020-03-09T16:04:49+11:00","author":"Caspian Baska","subject":"refactor: `ACAEngine` -> `PlaceOS`"}])))
    end

    describe "#details" do
      # WebMock
      #   .stub(:get, DOMAIN + "#{client.base}/repo-G03N8MjLRnz/details")
      #   .with(query: {"driver" => "drivers/place/spec_helper.cr", "commit" => "d3d0882"})
      #   .to_return(body: %([{"commit":"1b2de89","date":"2020-05-08T16:06:14+10:00","author":"Caspian Baska","subject":"refactor: migrate to Log"},{"commit":"2ee7ab1","date":"2020-04-08T14:08:20+10:00","author":"Stephen von Takach","subject":"feat: add feature test driver"},{"commit":"4be0571","date":"2020-03-12T13:03:00+11:00","author":"Caspian Baska","subject":"feat(place:private_helper): add an echo function"},{"commit":"ca54d2e","date":"2020-03-09T16:04:49+11:00","author":"Caspian Baska","subject":"refactor: `ACAEngine` -> `PlaceOS`"}]))

      # result = client.details id: "repo-G03N8MjLRnz", driver: "drivers/place/spec_helper.cr", commit: "d3d0882"
      # result.should be_a(Array(NamedTuple(commit: String, date: Time, author: String, subject: String)))
      # result.should eq(Array(NamedTuple(commit: String, date: Time, author: String, subject: String)).from_json(%([{"commit":"1b2de89","date":"2020-05-08T16:06:14+10:00","author":"Caspian Baska","subject":"refactor: migrate to Log"},{"commit":"2ee7ab1","date":"2020-04-08T14:08:20+10:00","author":"Stephen von Takach","subject":"feat: add feature test driver"},{"commit":"4be0571","date":"2020-03-12T13:03:00+11:00","author":"Caspian Baska","subject":"feat(place:private_helper): add an echo function"},{"commit":"ca54d2e","date":"2020-03-09T16:04:49+11:00","author":"Caspian Baska","subject":"refactor: `ACAEngine` -> `PlaceOS`"}])))
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
