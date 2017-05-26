defmodule Glayu.ConfigTest do

  use ExUnit.Case

  test "if no _conf.yml file is present an exception is fired" do

    assert_raise RuntimeError, "_config.yml file not found", fn ->
      Glayu.Config.load_config()
    end

  end

  test "if _conf.yml has an invalid format an exception is fired" do

    assert_raise RuntimeError, "Ivalid _config.yml file, field permalink: \"invalid permalink\"", fn ->
      Glayu.Config.load_config("./test/fixtures/invalid_conf")
    end

  end

end