defmodule Glayu.CLI.Publish do

  @behaviour Glayu.CLI.Command

  alias Glayu.Tasks.Publish

  def options do
    []
  end

  def aliases do
    []
  end

  def help do
    IO.ANSI.format(["\n",
      "glayu ", IO.ANSI.reset, IO.ANSI.light_cyan, "publish ", IO.ANSI.reset, "<", IO.ANSI.bright, "filename", IO.ANSI.reset, ">\n",
      "\n",
      "Publishes a draft.\n",
      "\n",
      "The markdown file will be moved from the ", IO.ANSI.bright,"source/_drafts", IO.ANSI.reset," directory to a directory under ", IO.ANSI.bright,"source/_posts", IO.ANSI.reset," following the permalik definition provided in ", IO.ANSI.bright, "_config.yml\n", IO.ANSI.reset,
      "\n",
      IO.ANSI.bright, "ARGUMENTS\n", IO.ANSI.reset,
      "\n",
      "<", IO.ANSI.bright, "filename", IO.ANSI.reset, ">\n",
      "Markdown source file. The file name or the file path can be provided.\n",
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
      |> Publish.run
      |> build_result
    else
      {:ok, help()}
    end
  end

  defp parse_args([filename]) do
    {:ok, [filename: filename]}
  end

  defp parse_args(_) do
    {:error, "Invalid number of arguments"}
  end

  defp build_result({:ok, %{status: :published, path: path}}) do
    {:ok, IO.ANSI.format(["🐦  Draft published to ", IO.ANSI.light_cyan, "#{path}", IO.ANSI.reset])}
  end

  defp build_result({:ok, %{status: :canceled, path: path}}) do 
    {:ok, IO.ANSI.format(["🐦  Previous published file ", IO.ANSI.light_cyan, "#{path}", IO.ANSI.reset, " has been preserved."])}
  end

end