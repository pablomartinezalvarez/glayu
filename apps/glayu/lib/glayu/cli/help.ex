defmodule Glayu.CLI.Help do

  @behaviour Glayu.CLI.Command

  alias Glayu.CLI.Utils

  def options do
    []
  end

  def aliases do
    []
  end

  def help do
    IO.ANSI.format(["\n",
      "glayu ", :reset, :light_cyan, "help ", :reset, "[", :bright, "command", :reset, "]\n",
      "\n",
      "Displays help.\n",
      "\n",
      "If ", :bright,"command", :reset," is not specified, all of the commands supported by Glayu are listed.\n",
      "\n",
      :bright, "ARGUMENTS\n", :reset,
      "\n",
      "[", :bright, "command", :reset, "]\n",
      "Displays help information on that command.\n",
      "\n"
    ])
  end

  def run([opts: [], args: [command]]) do

    if Enum.member?(Glayu.CLI.commands(), command) do
      {:ok, apply(Utils.get_command_module(command), :help, [])}
    else
      {:ok, list_commands()}
    end

  end

  def run(_) do
    {:ok, list_commands()}
  end

  defp list_commands() do
    IO.ANSI.format(["\n",
      :bright, "GLAYU COMMANDS\n", :reset,
      "\n",
      "glayu ", :reset, :light_cyan, "init ", :reset, "[", :bright, "folder", :reset, "]               Initializes the website.\n",
      "\n",
      "glayu ", :reset, :light_cyan, "new ", :reset, "[", :bright, "folder", :reset, "] <", :bright, "title", :reset, ">        Creates a new post or page.\n",
      "\n",
      "glayu ", :reset, :light_cyan, "publish ", :reset, "<", :bright, "filename", :reset, ">          Publishes a draft.\n",
      "\n",
      "glayu ", :reset, :light_cyan, "build ", :reset, "[", :bright, "-chp", :reset, "] [", :bright, "regex", :reset, "]        Generates the static files.\n",
      "\n",
      "glayu ", :reset, :light_cyan, "serve ", :reset, "[", :bright, "port", :reset, "]                Starts the preview server.\n",
      "\n",
      "glayu ", :reset, :light_cyan, "help ", :reset, "[", :bright, "command", :reset, "]              Displays help.\n",
      "\n"
    ])
  end

end