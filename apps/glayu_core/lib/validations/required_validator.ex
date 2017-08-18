defmodule Glayu.Validations.RequiredValidator do

  def validator do
    fn value ->
      if value == nil || value == '' || value == "" do
        {:error, "is required"}
      else
        {:ok, value}
      end
    end
    |> Saul.named_validator("required")
  end

end