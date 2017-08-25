defmodule Glayu.DocumentTest do

  use ExUnit.Case

  setup_all do
    Application.start(:yamerl)
    Glayu.Supervisor.start_link
    Glayu.Config.load_config_file("./test/fixtures/config/_config.yml", "./test/fixtures")
  end

  test "parsing a draft generates its doc context" do

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
    assert actual.layout == :post

  end

  test "parsing a page generates its doc context" do

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
    assert actual.layout == :page

  end

  test "parsing a page with multiple `---` generates its doc context" do

    expected_content =
    """
    <h1>Multiple Dashes</h1>
    <hr class=\"thin\"/>
    <p>after first dash</p>
    <hr class=\"thin\"/>
    <p>after second dash</p>
    <hr class=\"thin\"/>
    <p>after third dash</p>
    """

    actual = Glayu.Document.parse("./test/fixtures/source/pages/dashes.md")

    assert actual.title == "Dashes"
    assert actual.date == DateTime.from_naive!(~N[2017-07-18 14:55:00], "Etc/UTC")
    assert actual.author == "Pablo Martínez"
    assert actual.content == expected_content
    assert actual.source == Path.absname("./test/fixtures/source/pages/dashes.md")
    assert actual.type == :page
    assert actual.layout == :page

  end

  test "rendering a post with a custom layout generates the right HTML" do

    expected_html =
    """
    <html>
    <head><title>Tears in Rain</title></head>
    <body>
    <h1>This is a Custom Layout</h1>
    <h2>Tears in Rain</h2>
    <p>I’ve seen things you people wouldn’t believe. Attack ships on fire off the shoulder of Orion. I watched C-beams glitter in the dark near the Tannhäuser Gate. All those moments will be lost in time, like tears in rain. Time to die.</p>
    </body>
    </html>
    """

    doc_context = %{
      author: "Pablo Martinez",
      categories: [%{keys: ["custom-layout"], name: "Custom Layout", path: "/custom-layout/index.html"}],
      content: "<p>I’ve seen things you people wouldn’t believe. Attack ships on fire off the shoulder of Orion. I watched C-beams glitter in the dark near the Tannhäuser Gate. All those moments will be lost in time, like tears in rain. Time to die.</p>",
      date: DateTime.from_naive!(~N[2017-07-24 18:15:20], "Etc/UTC"),
      featured_image: "https://upload.wikimedia.org/wikipedia/en/1/1f/Tears_In_Rain.png",
      layout: :custom,
      path: "/custom-layout/2017/07/24/tears-in-rain.html",
      raw: "I've seen things you people wouldn't believe. Attack ships on fire off the shoulder of Orion. I watched C-beams glitter in the dark near the Tannhäuser Gate. All those moments will be lost in time, like tears in rain. Time to die.",
      source: "/Users/pablomartinez/Documents/development/workspaces/glayu/glayu/test/fixtures/source/_posts/custom-layout/2017/07/24/custom-layout.md",
      summary: "<p>I’ve seen things you people wouldn’t believe. Attack ships on fire off the shoulder of Orion. I watched C-beams glitter in the dark near the Tannhäuser Gate. All those moments will be lost in time, like tears in rain. Time to die.</p>",
      tags: ["Layouts"],
      title: "Tears in Rain",
      type: :post
    }

    Glayu.Build.TemplatesStore.start_link()
    Glayu.Build.TemplatesStore.add_templates(Glayu.Template.compile())

    assert Glayu.Document.render(doc_context) == expected_html

  end

end