defmodule Glayu.Utils.Code do

  def get_modules_adopting_behavior(type) do
    # Fetch all .beam files
    Path.wildcard(Path.join([Mix.Project.build_path, "**/ebin/**/*.beam"]))
    # Parse the BEAM for behaviour implementations
    |> Stream.map(fn path ->
      {:ok, {mod, chunks}} = :beam_lib.chunks('#{path}', [:attributes])
      {mod, get_in(chunks, [:attributes, :behaviour])}
    end)
    # Filter out behaviours we don't care about and duplicates
    |> Stream.filter(fn {_mod, behaviours} -> is_list(behaviours) && type in behaviours end)
    |> Enum.uniq
    |> Enum.map(fn {module, _} -> module end)
  end

end