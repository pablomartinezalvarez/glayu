defmodule Glayu.PermalinkTest do

  use ExUnit.Case

  setup_all do
    Glayu.Config.load_config("./test/fixtures")
  end

  test "permalink is extracted from a valid draft context" do

    doc_context = %{
      title: "Moon Jae-in becomes President of South Korea",
      date: DateTime.from_naive!(~N[2017-05-11 19:54:42], "Etc/UTC"),
      categories: [%{keys: ["world"], name: "World", path: "/world/index.html"}, %{keys: ["world", "asia"], name: "Asia", path: "/world/asia/index.html"}],
      type: :draft
    }

    assert Glayu.Permalink.from_context(doc_context) == ["world", "asia", "2017", "05", "11", "moon-jae-in-becomes-president-of-south-korea"]

  end

  test "permalink is extracted from a valid page context" do

    doc_context = %{
      title: "Elixir",
      date: DateTime.from_naive!(~N[2017-03-29 17:46:22], "Etc/UTC"),
      source: Path.absname("./test/fixtures/source/pages/elixir.md"),
      type: :page
    }

    assert Glayu.Permalink.from_context(doc_context) == ["pages", "elixir"]

  end

end