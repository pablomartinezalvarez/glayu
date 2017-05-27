defmodule Glayu.ConfigTest do

  use ExUnit.Case

  setup_all do
    Glayu.ConfigStore.reset()
  end

  test "if no _conf.yml file is present an exception is fired" do

    assert_raise RuntimeError, "_config.yml file not found", fn ->
      Glayu.Config.load_config()
    end

  end

  test "if _conf.yml has an invalid format an exception is fired" do

    assert_raise Glayu.Validations.ValidationError, "Validation Error:\n'public_dir': \"is required\"\n'permalink': \"invalid permalink format\"\n'theme_uri': \"invalid uri format\"", fn ->
      Glayu.Config.load_config("./test/fixtures/invalid_conf")
    end

  end

end