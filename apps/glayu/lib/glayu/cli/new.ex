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
      "glayu ", :reset, :light_cyan, "new ", :reset, "[", :bright, "folder", :reset, "] <", :bright, "title", :reset, ">\n",
      "\n",
      "Creates a new post or page.\n",
      "\n",
      "All new posts are considered drafts and will be placed under the ", :bright,"source/_drafts", :reset," directory, this directory will be skipped during a site build. When a post is ready it can be published using the ", :bright,"publish", :reset," command.\n",
      "\n",
      "All pages are placed under the ", :bright, "source", :reset," directory, and are rendered during a site build.\n",
      "\n",
      :bright, "ARGUMENTS\n", :reset,
      "\n",
      "[", :bright, "layout", :reset, "]\n",
      :bright, "post", :reset, " or ", :bright, "page", :reset, ". If no layout is provided, Glayu will use the post layout.\n",
      "\n",
      "<", :bright, "title", :reset, ">\n",
      "Article title. If the title contains spaces, surround it with quotation marks.\n",
      "\n"
    ])
  end

  def run(params) do

    {status, args} = parse_args(params[:args])

    if status == :ok do
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

  defp parse_args(["post", title]) do
    {:ok, [type: :post, title: title]}
  end

  defp parse_args(["page", title]) do
    {:ok, [type: :page, title: title]}
  end

  defp parse_args([_, _]) do
    {:error, "Invalid layout"}
  end

  defp parse_args(_) do
    {:error, "Invalid number of arguments"}
  end

  defp build_result({:ok, %{status: :new, path: path, type: type}}) do
    {:ok, IO.ANSI.format(["🐦  ", String.capitalize(to_string(type)), " created at ", :light_cyan, path, :reset])}
  end

  defp build_result({:ok, %{status: :exists, path: path, type: type}}) do
    {:ok, IO.ANSI.format([IO.ANSI.yellow, "⚠️  ", String.capitalize(to_string(type)), " ", :bright, path, :normal, " already exists.", :reset])}
  end

  defp build_result({:error, reason}) do
    {:error, reason}
  end

end