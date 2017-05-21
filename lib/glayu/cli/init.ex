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
      "glayu ", :reset, :light_cyan, "init ", :reset, "[", :bright, "folder", :reset, "]\n",
      "\n",
      "Initializes the website.\n",
      "\n",
      "If no ", :bright,"folder", :reset," is provided, the website will be configured in the current directory. If the destination folder exists and contains a ", :bright,"_config.yml", :reset," file, this configuration file will be used to initialize the site.\n",
      "\n",
      :bright, "ARGUMENTS\n", :reset,
      "\n",
      "[", :bright, "folder", :reset, "]\n",
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
    {:ok, IO.ANSI.format(["🐦  Your ", :light_cyan, "Glayu", :reset , " site has been created at ", :light_cyan, "#{Path.absname(dir)}"])}
  end

  defp build_result({:error, reason}, _) do
    {:error, reason}
  end

end