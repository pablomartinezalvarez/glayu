defmodule Glayu.Utils.PathRegexTest do

  use ExUnit.Case

  setup_all do
    Application.start(:yamerl)
    Glayu.Supervisor.start_link
    Glayu.Config.load_config_file("./test/fixtures/config/_config.yml", "./test/fixtures")
  end

  test "extract base dir from regex" do

    # Source relative Path
    assert Glayu.Utils.PathRegex.base_dir(".") == Path.absname("./test/fixtures/source")
    assert Glayu.Utils.PathRegex.base_dir("_posts/world/.*/2017/.*") == Path.absname("./test/fixtures/source/_posts/world")

    # Absolute Path
    assert Glayu.Utils.PathRegex.base_dir(Path.absname("./test/fixtures/source")) == Path.absname("./test/fixtures/source")
    assert Glayu.Utils.PathRegex.base_dir(Path.absname("./test/fixtures/source/_posts/world/.*/2017/.*")) == Path.absname("./test/fixtures/source/_posts/world")

  end

end