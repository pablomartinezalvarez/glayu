defmodule Glayu.Validations.ValidationError do

  @moduledoc """
  Exception raised when a document validation fails.
  """

  defexception [:errors]

  def message(exception) do
    Enum.reduce(exception.errors, "Validation Error:", fn({_, field, _, reason}, message) ->
      message <> "\n" <> inspect(field) <> ": " <> reason
    end)
  end

end