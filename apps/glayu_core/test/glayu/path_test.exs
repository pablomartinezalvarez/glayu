defmodule Glayu.PathTest do

  use ExUnit.Case

  setup_all do
    Application.start(:yamerl)
    Glayu.Supervisor.start_link
    :ok
  end

  test "source_root and public_root handles absolute paths" do
    Glayu.Config.load_config_file("./test/fixtures/config/_absolute_paths_config.yml", "./test/fixtures")
    assert Glayu.Path.source_root() == "/path/to/source"
    assert Glayu.Path.public_root() == "/path/to/public"
  end

  test "public_root handles relative paths" do
    Glayu.Config.load_config_file("./test/fixtures/config/_config.yml", "./test/fixtures")
    assert Glayu.Path.source_root() == Path.absname("./test/fixtures/source")
    assert Glayu.Path.public_root() == Path.absname("./test/fixtures/public")
  end

end
