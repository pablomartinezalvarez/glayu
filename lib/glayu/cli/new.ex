defmodule Glayu.CLI.New do

  @behaviour Glayu.CLI.Command

  alias Glayu.Tasks.New

  def options do
    []
  end

  def aliases do
    []
  end

  def help do
    """
    glayu new [layout] <title>

    Creates a new post or page.

    All new posts are considered drafts and will placed under the `source/_drafts` directory, this directory will be skipped during a site build. When a post is ready it can be published using the `publish` command.

    All pages are placed under the `source` directory, and are rendered during a site build.

    ARGUMENTS

    [layout]

    `post` or `page`. If no layout is provided, Glayu will use the post layout.

    <title>

    Article title. If the title contains spaces, surround it with quotation marks.
    """
  end

  def run(params) do
  	params[:args]
    |> parse_args
    |> New.run
    |> build_result
  end

  defp parse_args([title]) do
    [type: :post, title: title]
  end

  defp parse_args([layout, title]) do
    [type: String.to_atom(layout), title: title]
  end

  defp build_result({:ok, %{status: :new, path: path, type: type}}) do
    {:ok, IO.ANSI.format(["🐦  ", "#{String.capitalize(to_string(type))}", " created at ", :light_cyan, "#{path}"])}
  end

  defp build_result({:ok, %{status: :exists, path: path, type: type}}) do
    {:ok, IO.ANSI.format([:yellow, "⚠️  ", "#{String.capitalize(to_string(type))}", " ", :bright, "#{path}", :normal, " already exists."])}
  end

end