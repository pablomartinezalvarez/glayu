defmodule Glayu.Build.Jobs.BuildSiteTreeTest do

  use ExUnit.Case
  use Timex

  setup_all do
    Glayu.Config.load_config("./test/fixtures/build_site_tree")
    gen_test_site()
  end

  defp post_tpl(title,  date, categories, tags) do
    "---\n" <>
    "title: #{title}\n" <>
    "date: #{date}\n" <>
    "author: galyu\n" <>
    "categories:\n" <> string_list_to_yaml(categories) <>
    "tags:\n" <> string_list_to_yaml(tags) <>
    "---\n" <>
    "Nemo voluptatibus illum similique dolore. Quos cum neque et. Mollitia quis iusto cum sapiente. Vitae id omnis voluptatem dolor tenetur. Labore ut officiis accusantium eaque. Quos id eius at recusandae deleniti aperiam est.\n" <>
    "Vel aut blanditiis ipsum aut eum ab praesentium voluptatibus. Ullam quo quis numquam et explicabo ipsum est. Ducimus facilis odio quia nostrum.\n" <>
    "Sed et laboriosam ea atque nihil qui temporibus. Illo fugiat animi ut aut vel dignissimos animi quo. Ea numquam aut rem debitis. Culpa sint voluptatem qui. Iusto necessitatibus illo facilis commodi explicabo ut.\n" <>
    "A mollitia eum et voluptatem nemo. Suscipit esse repudiandae amet aliquid alias sit omnis itaque. Dolores molestiae vitae sit. Veniam hic doloremque qui tempore ducimus qui. Incidunt optio optio dolorem molestias dolor voluptas vitae. Ut omnis est omnis nulla quia quidem iusto.\n" <>
    "Reprehenderit eum veniam voluptas architecto tempora sed veniam. Consectetur nemo et velit delectus voluptatem voluptas pariatur autem. Perspiciatis ipsam est recusandae. Ratione amet hic perferendis.\n"
  end

  defp string_list_to_yaml(categories) do
    Enum.reduce(categories, "", fn (category, buff) -> buff <> "- #{category}\n" end)
  end

  defp create_post(path, title,  date, categories, tags) do
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, post_tpl(title,  date, categories, tags))
  end

  # Generated the test Site:
  #
  # _posts
  #   business
  #     markets
  #       2017
  #         01
  #           02
  #             post-10.md
  #           03
  #             post-11.md
  #           05
  #             post-12.md
  #             post-13.md
  #             post-14.md
  #             post-15.md
  #     media
  #       2017
  #         01
  #           01
  #             post-04.md
  #             post-05.md
  #             post-08.md
  #           21
  #             post-18.md
  #             post-19.md
  #             post-20.md
  #             post-21.md
  #             post-25.md
  #   world
  #     americas
  #       2017
  #         01
  #           01
  #             post-02.md
  #             post-07.md
  #           06
  #             post-16.md
  #     europe
  #       2017
  #         01
  #           01
  #             post-01.md
  #             post-03.md
  #             post-06.md
  #             post-09.md
  #           21
  #             post-17.md
  #             post-22.md
  #             post-23.md
  #             post-24.md
  defp gen_test_site do

    create_post("./test/fixtures/build_site_tree/source/_posts/world/europe/2017/01/01/post-01.md", "Post 01", "2017-01-01 00:01:00", ["World", "Europe"], ["Spain", "Madrid"])
    create_post("./test/fixtures/build_site_tree/source/_posts/world/americas/2017/01/01/post-02.md", "Post 02", "2017-01-01 00:02:00", ["World", "Americas"], ["US", "L.A."])
    create_post("./test/fixtures/build_site_tree/source/_posts/world/europe/2017/01/01/post-03.md", "Post 03", "2017-01-01 00:03:00", ["World", "Europe"], ["Germany", "Berlin"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/media/2017/01/01/post-04.md", "Post 04", "2017-01-01 00:04:00", ["Business", "Media"], ["National Amusements"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/media/2017/01/01/post-05.md", "Post 04", "2017-01-01 00:05:00", ["Business", "Media"], ["PRISA"])
    create_post("./test/fixtures/build_site_tree/source/_posts/world/europe/2017/01/01/post-06.md", "Post 06", "2017-01-01 00:06:00", ["World", "Europe"], ["Italy", "Rome"])
    create_post("./test/fixtures/build_site_tree/source/_posts/world/americas/2017/01/01/post-07.md", "Post 07", "2017-01-01 00:07:00", ["World", "Americas"], ["Colombia", "Barranquilla"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/media/2017/01/01/post-08.md", "Post 08", "2017-01-01 00:08:00", ["Business", "Media"], ["Sony"])
    create_post("./test/fixtures/build_site_tree/source/_posts/world/europe/2017/01/01/post-09.md", "Post 09", "2017-01-01 00:09:00", ["World", "Europe"], ["France", "Paris"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/markets/2017/01/02/post-10.md", "Post 10", "2017-01-02 00:10:00", ["Business", "Markets"], ["IBEX 35", "Spain"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/markets/2017/01/03/post-11.md", "Post 11", "2017-01-03 00:11:00", ["Business", "Markets"], ["Nasdaq", "US"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/markets/2017/01/05/post-12.md", "Post 12", "2017-01-05 00:12:00", ["Business", "Markets"], ["Nikkey 225", "Japan"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/markets/2017/01/05/post-13.md", "Post 13", "2017-01-05 00:13:00", ["Business", "Markets"], ["Dow Jones", "NY"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/markets/2017/01/05/post-14.md", "Post 14", "2017-01-05 00:14:00", ["Business", "Markets"], ["BIFFEX", "London"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/markets/2017/01/05/post-15.md", "Post 15", "2017-01-05 00:15:00", ["Business", "Markets"], ["NYSE Arca", "NY"])
    create_post("./test/fixtures/build_site_tree/source/_posts/world/americas/2017/01/06/post-16.md", "Post 16", "2017-01-06 00:16:00", ["World", "Americas"], ["Peru", "Lima"])
    create_post("./test/fixtures/build_site_tree/source/_posts/world/europe/2017/01/21/post-17.md", "Post 17", "2017-01-21 00:17:00", ["World", "Europe"], ["Spain", "Barcelona"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/media/2017/01/21/post-18.md", "Post 18", "2017-01-21 00:18:00", ["Business", "Media"], ["Bertelsmann"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/media/2017/01/21/post-19.md", "Post 19", "2017-01-21 00:19:00", ["Business", "Media"], ["Grupo Globo"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/media/2017/01/21/post-20.md", "Post 20", "2017-01-21 00:20:00", ["Business", "Media"], ["Televisa"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/media/2017/01/21/post-21.md", "Post 21", "2017-01-21 00:21:00", ["Business", "Media"], ["Walt Disney"])
    create_post("./test/fixtures/build_site_tree/source/_posts/world/europe/2017/01/21/post-22.md", "Post 22", "2017-01-21 00:22:00", ["World", "Europe"], ["Spain", "Bilbao"])
    create_post("./test/fixtures/build_site_tree/source/_posts/world/europe/2017/01/21/post-23.md", "Post 23", "2017-01-21 00:23:00", ["World", "Europe"], ["Ireland", "Dublin"])
    create_post("./test/fixtures/build_site_tree/source/_posts/world/europe/2017/01/21/post-24.md", "Post 24", "2017-01-21 00:24:00", ["World", "Europe"], ["France", "Bordeaux"])
    create_post("./test/fixtures/build_site_tree/source/_posts/business/media/2017/01/21/post-25.md", "Post 25", "2017-01-21 01:00:00", ["Business", "Media"], ["21 Century Fox"])

  end

  test "site tree generation" do

    nodes = [
      "./test/fixtures/build_site_tree/source/_posts/business/markets/2017/01/02",
      "./test/fixtures/build_site_tree/source/_posts/business/markets/2017/01/03",
      "./test/fixtures/build_site_tree/source/_posts/business/markets/2017/01/05",
      "./test/fixtures/build_site_tree/source/_posts/business/media/2017/01/01",
      "./test/fixtures/build_site_tree/source/_posts/business/media/2017/01/21",
      "./test/fixtures/build_site_tree/source/_posts/world/americas/2017/01/01",
      "./test/fixtures/build_site_tree/source/_posts/world/americas/2017/01/06",
      "./test/fixtures/build_site_tree/source/_posts/world/europe/2017/01/01",
      "./test/fixtures/build_site_tree/source/_posts/world/europe/2017/01/21"
    ]

    # sort by date desc
    sort_fn = fn doc_context1, doc_context2 ->
      comp = DateTime.compare(doc_context1[:date], doc_context2[:date])
      comp == :gt || comp == :eq
    end

    Glayu.Build.TaskSpawner.spawn(nodes, Glayu.Build.Jobs.BuildSiteTree, [sort_fn: sort_fn, num_posts: 3])

    # categories
    assert Glayu.Build.SiteTree.keys() == [["business"], ["business", "markets"], ["business", "media"], ["world"], ["world", "americas"], ["world", "europe"]]

    # tags
    assert Glayu.Build.SiteTree.tags() == ["21 Century Fox", "BIFFEX", "Barcelona", "Barranquilla", "Berlin", "Bertelsmann", "Bilbao", "Bordeaux", "Colombia", "Dow Jones", "Dublin", "France", "Germany", "Grupo Globo", "IBEX 35", "Ireland", "Italy", "Japan", "L.A.", "Lima", "London", "Madrid", "NY", "NYSE Arca", "Nasdaq", "National Amusements", "Nikkey 225", "PRISA", "Paris", "Peru", "Rome", "Sony", "Spain", "Televisa", "US", "Walt Disney"]

    # Node info extraction

    # root node
    root_node = Glayu.Build.SiteTree.get_node(["root"])
    assert root_node.name == "Home"
    assert root_node.path == "/index.html"
    root_children = Glayu.Build.SiteTree.get_children(["root"])
    assert length(root_children) == 2
    assert Enum.at(root_children,0).name == "Business"
    assert Enum.at(root_children,0).path == "/business/index.html"
    assert Enum.at(root_children,1).name == "World"
    assert Enum.at(root_children,1).path == "/world/index.html"

    # business node
    business_node = Glayu.Build.SiteTree.get_node(["business"])
    assert business_node.name == "Business"
    assert business_node.path == "/business/index.html"
    business_parent = Glayu.Build.SiteTree.get_parent(["business"])
    assert business_parent.name == "Home"
    assert business_parent.path == "/index.html"
    business_children = Glayu.Build.SiteTree.get_children(["business"])
    assert length(business_children) == 2
    assert Enum.at(business_children,0).name == "Markets"
    assert Enum.at(business_children,0).path == "/business/markets/index.html"
    assert Enum.at(business_children,1).name == "Media"
    assert Enum.at(business_children,1).path == "/business/media/index.html"

    # media node
    media_node = Glayu.Build.SiteTree.get_node(["business", "media"])
    assert media_node.name == "Media"
    assert media_node.path == "/business/media/index.html"
    media_parent = Glayu.Build.SiteTree.get_parent(["business", "media"])
    assert media_parent.name == "Business"
    assert media_parent.path == "/business/index.html"
    media_children = Glayu.Build.SiteTree.get_children(["business", "media"])
    assert length(media_children) == 0

    # Latest post

    # on root node
    root_posts = Glayu.Build.SiteTree.get(["root", :posts])
    assert length(root_posts) == 3
    assert Enum.at(root_posts,0).title == "Post 25"
    assert Enum.at(root_posts,1).title == "Post 24"
    assert Enum.at(root_posts,2).title == "Post 23"

    # on business node
    business_posts = Glayu.Build.SiteTree.get(["business", :posts])
    assert length(business_posts) == 3
    assert Enum.at(business_posts,0).title == "Post 25"
    assert Enum.at(business_posts,1).title == "Post 21"
    assert Enum.at(business_posts,2).title == "Post 20"

    # on business node
    business_posts = Glayu.Build.SiteTree.get(["business", "media", :posts])
    assert length(business_posts) == 3
    assert Enum.at(business_posts,0).title == "Post 25"
    assert Enum.at(business_posts,1).title == "Post 21"
    assert Enum.at(business_posts,2).title == "Post 20"

  after
    File.rm_rf!("./test/fixtures/build_site_tree/source/_posts")
  end

end