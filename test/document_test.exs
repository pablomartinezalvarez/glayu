defmodule Glayu.DocumentTest do

  use ExUnit.Case

  setup_all do
    Glayu.Config.load_config("./test/fixtures")
  end

  test "parse a draft generates its doc context" do

    expected_content =
    """
    <p>Moon Jae-in assumed the office of President of South Korea yesterday. He was announced the winner of Tuesday’s election, with 41.1% of the vote, and sworn in yesterday at the Korean National Assembly. Moon is succeeding the impeached President Park Geun-hye.</p>
    <p>Moon has promised to unite his country, which faces tensions due to the corruption scandals of the previous president. He has also vowed to promote peace between the two Koreas. One way Moon is attempting to improve the relationship between South Korea and North Korea is by reopening the Kaesong Industrial Region, an industrial park on the Korean border jointly run by both Koreas. Moon also wishes to reform chaebol, a type of conglomerate run by powerful families. An example of a chaebol is Samsung, whose vice-chariman Lee Jae-yong was arrested for allegations of bribery under the previous president Park Guen-hye.</p>
    <p>In more international affairs, Moon has said he is reconsidering the THAAD (Terminal High Altitude Area Defense) deployments of the United States, as he believes they could damage relations with China.</p>
    <p>Moon’s parents were North Korean refugees. He worked as a human rights lawyer after serving in the South Korean special forces.</p>
    """

    actual = Glayu.Document.parse("./test/fixtures/source/_drafts/moon-jae-in-becomes-president-of-south-korea.md")

    assert actual.title == "Moon Jae-in becomes President of South Korea"
    assert actual.date == DateTime.from_naive!(~N[2017-05-11 19:54:42], "Etc/UTC")
    assert actual.author == "Wikinews"
    assert actual.featured_image == "https://en.wikinews.org/wiki/Moon_Jae-in_becomes_President_of_South_Korea#/media/File:Moon_Jae-in_May_2017.jpg"
    assert actual.score == 10
    assert actual.summary == "<p>Moon Jae-in assumed the office of President of South Korea on Wednesday. He was announced the winner of Tuesday’s election, with 41.1% of the vote, and sworn in on Wednesday at the Korean National Assembly.</p>\n"
    assert actual.categories == [%{keys: ["world"], name: "World", path: "/world/index.html"}, %{keys: ["world", "asia"], name: "Asia", path: "/world/asia/index.html"}]
    assert actual.tags ==  ["South Korea", "president", "Moon Jae-in", "elections"]
    assert actual.content == expected_content
    assert actual.source == Path.absname("./test/fixtures/source/_drafts/moon-jae-in-becomes-president-of-south-korea.md")
    assert actual.type == :draft

  end

  test "parse a page generates its doc context" do

    expected_content =
    """
    <h1>Elixir</h1>
    <p>An elixir (from Arabic: إكسير - Iksīr; from Greek xērion powder for drying wounds from xēros dry) is a clear, sweet-flavored liquid used for medicinal purposes, to be taken orally and intended to cure one’s illness. When used as a pharmaceutical preparation, an elixir contains at least one active ingredient designed to be taken orally.</p>
    """

    actual = Glayu.Document.parse("./test/fixtures/source/pages/elixir.md")

    assert actual.title == "Elixir"
    assert actual.date == DateTime.from_naive!(~N[2017-03-29 17:46:22], "Etc/UTC")
    assert actual.original_source == "https://en.wikipedia.org/wiki/Elixir"
    assert actual.author == "Wikipedia"
    assert actual.content == expected_content
    assert actual.source == Path.absname("./test/fixtures/source/pages/elixir.md")
    assert actual.type == :page

  end

end