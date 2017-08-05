defmodule Glayu.Build.Jobs.BuildSiteTreeTest do

  use ExUnit.Case
  use Timex

  setup_all do
    Glayu.Config.load_config_file("./test/fixtures/build_site_tree/_config.yml", "./test/fixtures/build_site_tree")
    Glayu.Build.Supervisor.start_link()
    SiteHelper.gen_test_site("build_site_tree")

    on_exit fn ->
      File.rm_rf!("./test/fixtures/build_site_tree/source/")
    end

  end

  test "site tree generation" do

    nodes = [
      "./test/fixtures/build_site_tree/source/",
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

    pages = Enum.sort(Glayu.Build.SiteTree.pages(), &(&1[:title] <= &2[:title]))
    assert length(pages) == 5
    assert Enum.at(pages,0).title == "Contact"
    assert Enum.at(pages,1).title == "Help"
    assert Enum.at(pages,2).title == "Privacy Policy"
    assert Enum.at(pages,3).title == "Site Map"
    assert Enum.at(pages,4).title == "Terms of Service"

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

    # Latest posts

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

    # on media node
    media_posts = Glayu.Build.SiteTree.get(["business", "media", :posts])
    assert length(media_posts) == 3
    assert Enum.at(media_posts,0).title == "Post 25"
    assert Enum.at(media_posts,1).title == "Post 21"
    assert Enum.at(media_posts,2).title == "Post 20"

  end

end