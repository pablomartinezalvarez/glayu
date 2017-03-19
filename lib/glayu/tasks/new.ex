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
    Path.draft_source_path title
  end

  defp get_path({:page, title}) do
    Path.page_source_path title
  end

  defp create_file(path, {:post, title}) do
    File.write(path, Glayu.Templates.Post.tpl(title))
  end

  defp create_file(path, {:page, title}) do
    File.write(path, Glayu.Templates.Page.tpl(title))
  end

end