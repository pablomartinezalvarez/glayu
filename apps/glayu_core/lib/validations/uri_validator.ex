defmodule Glayu.Validations.URIValidator do

  def validator do
    fn value ->
      if value != nil && valid_uri?(value) do
        {:ok, value}
      else
        {:error, "invalid uri format"}
      end
    end
    |> Saul.named_validator("valid_uri")
  end

  defp valid_uri?(str) do
    uri = URI.parse(str)
    case uri do
      %URI{scheme: nil} -> false
      %URI{host: nil} -> false
      %URI{path: nil} -> false
      _ -> true
    end
  end

end