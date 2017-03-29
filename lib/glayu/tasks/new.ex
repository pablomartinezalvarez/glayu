defmodule Glayu.Tasks.New do
  
  @behaviour Glayu.Tasks.Task

  @doc """
  Run the new post task
  """
  def run(params) do
    get_path(params[:title], params[:type])
    |> create_file(params[:title], params[:type])
    {:ok,""}
  end

  defp get_path(title, :post) do
    Glayu.Path.source_from_title(title, :draft)
  end

  defp get_path(title, :page) do
    Glayu.Path.source_from_title(title, :page)
  end

  defp create_file(path, title, :post) do
    File.write(path, Glayu.Templates.Post.tpl(title))
  end

  defp create_file(path, title, :page) do
    File.write(path, Glayu.Templates.Page.tpl(title))
  end

end