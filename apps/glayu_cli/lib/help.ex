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
      "glayu ", IO.ANSI.reset, IO.ANSI.light_cyan, "help ", IO.ANSI.reset, "[", IO.ANSI.bright, "command", IO.ANSI.reset, "]\n",
      "\n",
      "Displays help.\n",
      "\n",
      "If ", IO.ANSI.bright,"command", IO.ANSI.reset," is not specified, all of the commands supported by Glayu are listed.\n",
      "\n",
      IO.ANSI.bright, "ARGUMENTS\n", IO.ANSI.reset,
      "\n",
      "[", IO.ANSI.bright, "command", IO.ANSI.reset, "]\n",
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
      IO.ANSI.bright, "GLAYU COMMANDS\n", IO.ANSI.reset,
      "\n",
      "glayu ", IO.ANSI.reset, IO.ANSI.light_cyan, "init ", IO.ANSI.reset, "[", IO.ANSI.bright, "folder", IO.ANSI.reset, "]               Initializes the website.\n",
      "\n",
      "glayu ", IO.ANSI.reset, IO.ANSI.light_cyan, "new ", IO.ANSI.reset, "[", IO.ANSI.bright, "folder", IO.ANSI.reset, "] <", IO.ANSI.bright, "title", IO.ANSI.reset, ">        Creates a new post or page.\n",
      "\n",
      "glayu ", IO.ANSI.reset, IO.ANSI.light_cyan, "publish ", IO.ANSI.reset, "<", IO.ANSI.bright, "filename", IO.ANSI.reset, ">          Publishes a draft.\n",
      "\n",
      "glayu ", IO.ANSI.reset, IO.ANSI.light_cyan, "build ", IO.ANSI.reset, "[", IO.ANSI.bright, "-chp", IO.ANSI.reset, "] [", IO.ANSI.bright, "regex", IO.ANSI.reset, "]        Generates the static files.\n",
      "\n",
      "glayu ", IO.ANSI.reset, IO.ANSI.light_cyan, "serve ", IO.ANSI.reset, "[", IO.ANSI.bright, "port", IO.ANSI.reset, "]                Starts the preview server.\n",
      "\n",
      "glayu ", IO.ANSI.reset, IO.ANSI.light_cyan, "help ", IO.ANSI.reset, "[", IO.ANSI.bright, "command", IO.ANSI.reset, "]              Displays help.\n",
      "\n"
    ])
  end

end