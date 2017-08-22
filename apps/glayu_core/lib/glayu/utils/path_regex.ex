defmodule Glayu.Utils.PathRegex do

  def base_dir(nil) do
    Glayu.Path.source_root()
  end

  def base_dir(regex) do

    names = Regex.named_captures(~r/(?<base_path>[^.^$*+?()[{\|]+)/, regex)

    path = names["base_path"]

    case path do
      nil -> Glayu.Path.source_root
      path ->
        if String.starts_with?(regex, Glayu.Path.source_root()) do
          String.replace_suffix(path, "/", "")
        else
          Path.join(Glayu.Path.source_root(), path)
        end
    end

  end

end