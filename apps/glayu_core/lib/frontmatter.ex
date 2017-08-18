defmodule Glayu.FrontMatter do

  alias Glayu.Utils.Yaml

  def parse(frontmatter) do
    frontmatter
    |> :yamerl_constr.string
    |> List.flatten
    |> Yaml.to_map
  end

end