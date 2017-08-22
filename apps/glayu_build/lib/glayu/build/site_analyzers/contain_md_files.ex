defmodule Glayu.Build.SiteAnalyzer.ContainMdFiles do

  @behaviour Glayu.Build.SiteAnalyzer

  @md_ext ".md"

  def nodes(root, regex) do
    scan_path(root, [], regex)
  end

  defp scan_path(path, nodes, regex) do
    if path != Glayu.Path.source_root(:draft) do
      scan_files(File.ls!(path), path, false, regex) ++ nodes
    else
      nodes
    end
  end

  defp scan_files([file|other_files], path, has_regular_files, regex) do
    child_path = Path.join(path, file)
    cond do
      File.dir?(child_path) ->
        scan_path(child_path, scan_files(other_files, path, has_regular_files, regex), regex)
      File.regular?(child_path) && Path.extname(child_path) == @md_ext && (!regex || Regex.match?(regex, path)) ->
        if has_regular_files do
          scan_files(other_files, path, true, regex)
        else
          [path|scan_files(other_files, path, true, regex)]
        end
      true ->
          scan_files(other_files, path, has_regular_files, regex)
    end
  end

  defp scan_files([], _, _, _) do
    []
  end

end

