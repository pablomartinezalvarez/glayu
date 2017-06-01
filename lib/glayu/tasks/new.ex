defmodule Glayu.Tasks.New do

  @behaviour Glayu.Tasks.Task

  @doc """
  Run the new post task
  """
  def run(params) do

    Glayu.Config.load_config()
    Glayu.SiteChecker.check!()

    type = params[:type]
    title = params[:title]

    create_md_file(calculate_path(title, type), title, type)

  end

  defp create_md_file({:ok, path}, title, type) do
    if File.exists?(path) do
      {:ok, %{status: :exists, path: path, type: type}}
    else
      create_file(path, title, type)
      {:ok, %{status: :new, path: path, type: type}}
    end
  end

  defp create_md_file({:error, details}, _, _) do
    {:error, details}
  end

  defp calculate_path(title, :post) do
    Glayu.Path.source_from_title(title, :draft)
  end

  defp calculate_path(title, :page) do
    Glayu.Path.source_from_title(title, :page)
  end

  defp create_file(path, title, :post) do
    File.write(path, Glayu.Templates.Post.tpl(title))
  end

  defp create_file(path, title, :page) do
    File.write(path, Glayu.Templates.Page.tpl(title))
  end

end