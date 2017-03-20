defmodule Glayu.Tasks.New do
  
  @moduledoc """
  This task creates a new post with the given post title.
  """

  alias Glayu.Path

  @doc """
  Run the new post task
  """
  def run(params) do
    params 
    |> get_path
    |> create_file(params)
  end

  defp get_path({:post, title}) do
    Path.source_draft_path_from_title(title)
  end

  defp get_path({:page, title}) do
    Path.source_page_path_from_title(title)
  end

  defp create_file(path, {:post, title}) do
    File.write(path, Glayu.Templates.Post.tpl(title))
  end

  defp create_file(path, {:page, title}) do
    File.write(path, Glayu.Templates.Page.tpl(title))
  end

end