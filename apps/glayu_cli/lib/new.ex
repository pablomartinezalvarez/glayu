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
    IO.ANSI.format(["\n",
      "glayu ", IO.ANSI.reset, IO.ANSI.light_cyan, "new ", IO.ANSI.reset, "[", IO.ANSI.bright, "folder", IO.ANSI.reset, "] <", IO.ANSI.bright, "title", IO.ANSI.reset, ">\n",
      "\n",
      "Creates a new post or page.\n",
      "\n",
      "All new posts are considered drafts and will be placed under the ", IO.ANSI.bright,"source/_drafts", IO.ANSI.reset," directory, this directory will be skipped during a site build. When a post is ready it can be published using the ", IO.ANSI.bright,"publish", IO.ANSI.reset," command.\n",
      "\n",
      "All pages are placed under the ", IO.ANSI.bright, "source", IO.ANSI.reset," directory, and are rendered during a site build.\n",
      "\n",
      IO.ANSI.bright, "ARGUMENTS\n", IO.ANSI.reset,
      "\n",
      "[", IO.ANSI.bright, "layout", IO.ANSI.reset, "]\n",
      IO.ANSI.bright, "post", IO.ANSI.reset, " or ", IO.ANSI.bright, "page", IO.ANSI.reset, ". If no layout is provided, Glayu will use the post layout.\n",
      "\n",
      "<", IO.ANSI.bright, "title", IO.ANSI.reset, ">\n",
      "Article title. If the title contains spaces, surround it with quotation marks.\n",
      "\n"
    ])
  end

  def run(params) do

    {status, args} = parse_args(params[:args])

    if status == :ok do

      Application.start(:yamerl)
      Application.start(:eex)
      Application.start(:glayu_core)

      args
      |> New.run
      |> build_result
    else
      {:ok, help()}
    end
  end

  defp parse_args([title]) do
    {:ok, [type: :post, title: title]}
  end

  defp parse_args([layout, title]) do
    if Enum.member?(["post", "page"], layout) do
      {:ok, [type: String.to_atom(layout), title: title]}
    else
      {:error, "Invalid layout"}
    end
  end

  defp parse_args(_) do
    {:error, "Invalid number of arguments"}
  end

  defp build_result({:ok, %{status: :new, path: path, type: type}}) do
    {:ok, IO.ANSI.format(["🐦  ", "#{String.capitalize(to_string(type))}", " created at ", IO.ANSI.light_cyan, "#{path}", IO.ANSI.reset])}
  end

  defp build_result({:ok, %{status: :exists, path: path, type: type}}) do
    {:ok, IO.ANSI.format([IO.ANSI.yellow, "⚠️  ", "#{String.capitalize(to_string(type))}", " ", IO.ANSI.bright, "#{path}", IO.ANSI.normal, " already exists.", IO.ANSI.reset])}
  end

  defp build_result({:error, reason}) do
    {:error, reason}
  end

end