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
      "glayu ", :reset, :light_cyan, "publish ", :reset, "<", :bright, "filename", :reset, ">\n",
      "\n",
      "Publishes a draft.\n",
      "\n",
      "The markdown file will be moved from the ", :bright,"source/_drafts", :reset," directory to a directory under ", :bright,"source/_posts", :reset," following the permalik definition provided in ", :bright, "_config.yml\n", :reset,
      "\n",
      :bright, "ARGUMENTS\n", :reset,
      "\n",
      "<", :bright, "filename", :reset, ">\n",
      "Markdown source file. The file name or the file path can be provided.\n",
      "\n"
    ])
  end

  def run(params) do

    Glayu.Config.load_config()

    {status, args} = parse_args(params[:args])

    if status == :ok do
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
    {:ok, IO.ANSI.format(["🐦  Draft published to ", :light_cyan, "#{path}"])}
  end

  defp build_result({:ok, %{status: :canceled, path: path}}) do 
    {:ok, IO.ANSI.format(["🐦  Previous published file ", :light_cyan, "#{path}", :reset, " has been preserved."])}
  end

end