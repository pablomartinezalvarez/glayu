defmodule Glayu.Validations.PermalinkConfValidator do

  @permalink_valid_tokens ["categories", "day", "month", "title", "year"]

  def validator do
    fn value ->
      if value != nil do
        tokens = Enum.filter(String.split(value, "/"), &(&1 != ""))
        if length(tokens) > 0 && valid_permalink(tokens, @permalink_valid_tokens) do
          {:ok, value}
        else
          {:error, "invalid permalink format"}
        end
      else
        {:error, "invalid permalink format"}
      end
    end
    |> Saul.named_validator("permalink_conf")
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

end