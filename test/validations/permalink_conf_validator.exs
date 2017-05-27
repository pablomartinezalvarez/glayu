defmodule Glayu.Validations.PermalinkConfValidatorTest do

  use ExUnit.Case

  test "permalink_config validator handles valid expresions" do

    {status, details} = Saul.validate("categories/year/month/day/title", Glayu.Validations.PermalinkConfValidator.validator())
    assert status == :ok
    assert details == "categories/year/month/day/title"

    {status, details} = Saul.validate("/title", Glayu.Validations.PermalinkConfValidator.validator())
    assert status == :ok
    assert details == "/title"

  end

  test "permalink_config validator handles invalid expresions" do

    {status, details} = Saul.validate(nil, Glayu.Validations.PermalinkConfValidator.validator())
    assert status == :error
    assert details.reason == "\"invalid permalink\""

    {status, details} = Saul.validate("", Glayu.Validations.PermalinkConfValidator.validator())
    assert status == :error
    assert details.reason == "\"invalid permalink\""

    {status, details} = Saul.validate("/", Glayu.Validations.PermalinkConfValidator.validator())
    assert status == :error
    assert details.reason == "\"invalid permalink\""

    {status, details} = Saul.validate("categories/year/categories/title", Glayu.Validations.PermalinkConfValidator.validator())
    assert status == :error
    assert details.reason == "\"invalid permalink\""

    {status, details} = Saul.validate("categories/unknown/title", Glayu.Validations.PermalinkConfValidator.validator())
    assert status == :error
    assert details.reason == "\"invalid permalink\""

  end

end