defmodule Glayu.ValidatorTest do

  use ExUnit.Case

  test "permalink_config validator handles valid expresions" do

    {status, details} = Saul.validate("categories/year/month/day/title", Glayu.Validator.permalink_conf())
    assert status == :ok
    assert details == "categories/year/month/day/title"

    {status, details} = Saul.validate("/title", Glayu.Validator.permalink_conf())
    assert status == :ok
    assert details == "/title"

  end

  test "permalink_config validator handles invalid expresions" do

    {status, details} = Saul.validate(nil, Glayu.Validator.permalink_conf())
    assert status == :error
    assert details.reason == "\"invalid permalink\""

    {status, details} = Saul.validate("", Glayu.Validator.permalink_conf())
    assert status == :error
    assert details.reason == "\"invalid permalink\""

    {status, details} = Saul.validate("/", Glayu.Validator.permalink_conf())
    assert status == :error
    assert details.reason == "\"invalid permalink\""

    {status, details} = Saul.validate("categories/year/categories/title", Glayu.Validator.permalink_conf())
    assert status == :error
    assert details.reason == "\"invalid permalink\""

    {status, details} = Saul.validate("categories/unknown/title", Glayu.Validator.permalink_conf())
    assert status == :error
    assert details.reason == "\"invalid permalink\""

  end

  test "uri validator handles valid expresions" do

    {status, details} = Saul.validate("http://glayu.com/", Glayu.Validator.uri())
    assert status == :ok
    assert details == "http://glayu.com/"

    {status, details} = Saul.validate("https://glayu.com/docs", Glayu.Validator.uri())
    assert status == :ok
    assert details == "https://glayu.com/docs"

    {status, details} = Saul.validate("https://glayu.com/?q=\"themes\"", Glayu.Validator.uri())
    assert status == :ok
    assert details == "https://glayu.com/?q=\"themes\""

  end

  test "uri validator handles invalid expresions" do

    {status, details} = Saul.validate(nil, Glayu.Validator.uri())
    assert status == :error
    assert details.reason == "\"invalid uri format\""

    {status, details} = Saul.validate("", Glayu.Validator.uri())
    assert status == :error
    assert details.reason == "\"invalid uri format\""

    # No scheme
    {status, details} = Saul.validate("glayu.com", Glayu.Validator.uri())
    assert status == :error
    assert details.reason == "\"invalid uri format\""

    # Invalid host
    {status, details} = Saul.validate("http://glayu", Glayu.Validator.uri())
    assert status == :error
    assert details.reason == "\"invalid uri format\""

    # No path
    {status, details} = Saul.validate("http://glayu.com", Glayu.Validator.uri())
    assert status == :error
    assert details.reason == "\"invalid uri format\""

  end

end