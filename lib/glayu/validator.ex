defmodule Glayu.Validator do

  @permalink_valid_tokens ["categories", "day", "month", "title", "year"]

  def yml_required do
    fn value ->
      if value == nil || value == '' || value == "" do
        {:error, "required value"}
      else
        {:ok, value}
      end
    end
    |> Saul.named_validator("yml_required")
  end

  def permalink_conf do
    fn value ->
      if value != nil do
        tokens = Enum.filter(String.split(value, "/"), &(&1 != ""))
        if length(tokens) > 0 && valid_permalink(tokens, @permalink_valid_tokens) do
          {:ok, value}
        else
          {:error, "invalid permalink"}
        end
      else
        {:error, "invalid permalink"}
      end
    end
    |> Saul.named_validator("permalink_conf")
  end

  def uri do
    fn value ->
      if value != nil && valid_uri?(value) do
        {:ok, value}
      else
        {:error, "invalid uri format"}
      end
    end
    |> Saul.named_validator("valid_uri")
  end

  defp valid_permalink([], _) do
    true
  end

  defp valid_permalink([token | tokens], allowed) do
    if Enum.member?(allowed, token) do
      valid_permalink(tokens, List.delete(allowed, token))
    else
      false
    end
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