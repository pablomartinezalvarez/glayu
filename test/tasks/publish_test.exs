defmodule Glayu.Tasks.PublishTest do

  use ExUnit.Case

  import ExUnit.CaptureIO

  setup_all do
    Glayu.Config.load_config("./test/fixtures")
    gen_draft()
  end

  defp gen_draft do

    content =
    """
    ---
    title: Salvador Sobral wins Eurovision for Portugal
    date: 2017-05-15 08:02:15
    author: Wikinews
    featured_image: https://en.wikinews.org/wiki/Salvador_Sobral_wins_Eurovision_for_Portugal?dpl_id=2815642#/media/File:Salvador_Sobral_RedCarpet_Kyiv_2017.jpg
    score: 10
    summary: On Saturday, Portugal won its first victory at the Eurovision song competition, held this year at Kiev's International Exhibition Centre in Ukraine.
    categories:
    - World
    - Europe
    tags:
    - Eurovision
    - Portugal
    - Salvador Sobral
    ---
    On Saturday, Portugal won its first victory at the Eurovision song competition, held this year at Kiev's International Exhibition Centre in Ukraine. Salvador Sobral's song Amar Pelos Dois won 758 points from public and professional judges. Bulgaria and Moldova came second and third respectively. Sobral called it "a victory for music".

    Out of 42 countries participating this time, 26 countries including hosts Ukraine and the Big Five — France, Germany, Italy, Spain and the United Kingdom — competed in the finals. The competition began on May 9. Sobral, who has a serious heart problem, did not perform during early rehearsals. Ukraine, Germany and Spain ended up at the bottom of the vote ranking winning collecting respectively 36, six and five points.

    UK representative Lucie Jones secured fifteenth place with 111 points. Sobral's ballad was written by his sister, who joined the 27-year-old winner on the stage during the reprise. Winner of the second semi-final Bulgaria's Kristian Kostov secured 615 points from the voting and Moldova won 374 points. Last year, Ukrainian singer Jamala scored 534 points, then highest in the competition, but this year won only 36 points.

    Portugal made its first appearance in the competition in 1964. The European Broadcast Union (EBU) warned Sobral against breaking the rules of the contest after he wore a t-shirt with "S.O.S.Refugees" written on it in a press conference following the first semi-final which Portugal had won. The Portuguese said, "If I'm here and I have European exposure, the least thing I can do is a humanitarian message [...] People come to Europe in plastic boats and are being asked to show their birth certificates in order to enter a country. These people are not immigrants, they're refugees running from death. Make no mistake. There is so much bureaucratic stuff happening in the refugee camps in Greece, Turkey, and Italy and we should help create legal and safe pathways from these countries to their destiny countries" EBU banned him from wearing t-shirts with politically motivated messages.

    Kasia Moś, representing Poland, said that she dedicated her performance to animal rights and added "I just hope that after this in Poland we’re going to change the law and we will not have dogs on chains".

    Eurovision reported the final was watched by four million viewers on YouTube.

    As the winner of this edition of the competition, Portugal is to host next year's competition. Two-time winner of the competition Ukraine previously hosted the 2005 contest.
    """

    File.write("./test/fixtures/source/_drafts/salvador-sobral-wins-eurovision-for-portugal.md", content)

  end

  test "publish a draft moves the markdown file to _posts folder" do

    params = [filename: "salvador-sobral-wins-eurovision-for-portugal.md"]

    {status, result} = Glayu.Tasks.Publish.run(params)

    assert status == :ok
    assert result.status == :published
    assert result.path == Path.absname("./test/fixtures/source/_posts/world/europe/2017/05/15/salvador-sobral-wins-eurovision-for-portugal.md")
    assert File.regular?("./test/fixtures/source/_posts/world/europe/2017/05/15/salvador-sobral-wins-eurovision-for-portugal.md")
    refute File.exists?("./test/fixtures/source/_drafts/salvador-sobral-wins-eurovision-for-portugal.md")

  after
    File.rm!("./test/fixtures/source/_posts/world/europe/2017/05/15/salvador-sobral-wins-eurovision-for-portugal.md")
  end

  test "publish a draft prompts user before overriding an existing file" do

    params = [filename: "cyberattack-not-hbo-comedian-caused-website-wipeout-says-fcc.md"]

    assert capture_io([input: "no"], fn ->  Glayu.Tasks.Publish.run(params) end) == "\e[33m⚠️  Destination file \e[1m" <> Path.absname("test/fixtures/source/_posts/us/2017/05/10/cyberattack-not-hbo-comedian-caused-website-wipeout-says-fcc.md") <> "\e[22m already exists\e[0m\nWhould you like to override it? "

  end

  test "publish a draft, providing a file that doesn't exists throws an exception'" do

    assert_raise File.Error, "could not read file \"" <> Path.absname("test/fixtures/source/_drafts/unknown.md") <> "\": no such file or directory", fn ->
      Glayu.Tasks.Publish.run([filename: "unknown.md"])
    end

  end

end