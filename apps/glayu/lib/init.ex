defmodule Glayu.CLI.Init do

  @behaviour Glayu.CLI.Command

  alias Glayu.Tasks.Init

  def options do
    []
  end

  def aliases do
    []
  end

  def help do
    IO.ANSI.format(["\n",
      "glayu ", IO.ANSI.reset, IO.ANSI.light_cyan, "init ", IO.ANSI.reset, "[", IO.ANSI.bright, "folder", IO.ANSI.reset, "]\n",
      "\n",
      "Initializes the website.\n",
      "\n",
      "If no ", IO.ANSI.bright,"folder", IO.ANSI.reset," is provided, the website will be configured in the current directory. If the destination folder exists and contains a ", IO.ANSI.bright,"_config.yml", IO.ANSI.reset," file, this configuration file will be used to initialize the site.\n",
      "\n",
      IO.ANSI.bright, "ARGUMENTS\n", IO.ANSI.reset,
      "\n",
      "[", IO.ANSI.bright, "folder", IO.ANSI.reset, "]\n",
      "Website destination folder. If the destination folder doesn't exists the full path to it will be created.\n",
      "\n"
    ])
  end

  def run(params) do
    {status, args} = parse_args(params[:args])

    if status == :ok do

      args
      |> Init.run
      |> build_result(args[:folder])
    else
      {:ok, help()}
    end
  end

  defp parse_args([]) do
    {:ok, [folder: "./"]}
  end

  defp parse_args([folder]) do
    {:ok, [folder: folder]}
  end

  defp parse_args(_) do
    {:error, "Invalid number of arguments"}
  end

  defp build_result(:ok, dir) do
    {:ok, IO.ANSI.format(["🐦  Your ", IO.ANSI.light_cyan, "Glayu", IO.ANSI.reset , " site has been created at ", IO.ANSI.light_cyan, "#{Path.absname(dir)}", IO.ANSI.reset])}
  end

  defp build_result({:error, reason}, _) do
    {:error, reason}
  end

end