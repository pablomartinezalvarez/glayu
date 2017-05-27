defmodule Glayu.Validations.URIValidatorTest do

  use ExUnit.Case

  test "uri validator handles valid expresions" do

    {status, details} = Saul.validate("http://glayu.com/", Glayu.Validations.URIValidator.validator())
    assert status == :ok
    assert details == "http://glayu.com/"

    {status, details} = Saul.validate("https://glayu.com/docs", Glayu.Validations.URIValidator.validator())
    assert status == :ok
    assert details == "https://glayu.com/docs"

    {status, details} = Saul.validate("https://glayu.com/?q=\"themes\"", Glayu.Validations.URIValidator.validator())
    assert status == :ok
    assert details == "https://glayu.com/?q=\"themes\""

  end

  test "uri validator handles invalid expresions" do

    {status, details} = Saul.validate(nil, Glayu.Validations.URIValidator.validator())
    assert status == :error
    assert details.reason == "\"invalid uri format\""

    {status, details} = Saul.validate("", Glayu.Validations.URIValidator.validator())
    assert status == :error
    assert details.reason == "\"invalid uri format\""

    # No scheme
    {status, details} = Saul.validate("glayu.com", Glayu.Validations.URIValidator.validator())
    assert status == :error
    assert details.reason == "\"invalid uri format\""

    # Invalid host
    {status, details} = Saul.validate("http://glayu", Glayu.Validations.URIValidator.validator())
    assert status == :error
    assert details.reason == "\"invalid uri format\""

    # No path
    {status, details} = Saul.validate("http://glayu.com", Glayu.Validations.URIValidator.validator())
    assert status == :error
    assert details.reason == "\"invalid uri format\""

  end

end