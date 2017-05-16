defmodule Glayu.Tasks.NewTest do

  use ExUnit.Case

  setup_all do
    Glayu.Config.load_config("./test/fixtures")
  end

  test "new post creates the markdown file" do

    params = [type: :post, title: "Changing position, President Trump says FBI Director Comey was fired over Russia investigation, showboating"]

    {status, result} = Glayu.Tasks.New.run(params)

    assert status == :ok
    assert result.status == :new
    assert result.path == Path.absname("./test/fixtures/source/_drafts/changing-position-president-trump-says-fbi-director-comey-was-fired-over-russia-investigation-showboating.md")
    assert result.type == :post
    assert File.regular?("./test/fixtures/source/_drafts/changing-position-president-trump-says-fbi-director-comey-was-fired-over-russia-investigation-showboating.md")
  after
    File.rm_rf!("./test/fixtures/source/_drafts/changing-position-president-trump-says-fbi-director-comey-was-fired-over-russia-investigation-showboating.md")
  end

  test "new post doesn't alter a previous file" do

    previous_content = File.read!("./test/fixtures/source/_drafts/moon-jae-in-becomes-president-of-south-korea.md")

    params = [type: :post, title: "Moon Jae-in becomes President of South Korea"]

    {status, result} = Glayu.Tasks.New.run(params)

    current_content = File.read!("./test/fixtures/source/_drafts/moon-jae-in-becomes-president-of-south-korea.md")

    assert status == :ok
    assert result.status == :exists
    assert result.path == Path.absname("./test/fixtures/source/_drafts/moon-jae-in-becomes-president-of-south-korea.md")
    assert result.type == :post

    assert File.regular?("./test/fixtures/source/_drafts/moon-jae-in-becomes-president-of-south-korea.md")
    assert current_content == previous_content

  end

  test "new page creates the markdown file" do

    params = [type: :page, title: "Open Source Static Site Generators"]

    {status, result} = Glayu.Tasks.New.run(params)

    assert status == :ok
    assert result.status == :new
    assert result.path == Path.absname("./test/fixtures/source/open-source-static-site-generators.md")
    assert result.type == :page
    assert File.regular?("./test/fixtures/source/open-source-static-site-generators.md")
  after
    File.rm!("./test/fixtures/source/open-source-static-site-generators.md")
  end

end