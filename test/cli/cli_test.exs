defmodule Glayu.CLITest do

  use ExUnit.Case
  import ExUnit.CaptureIO

  test "help is displayed with an unknown command" do
    assert capture_io(fn ->  Glayu.CLI.main(["unknown-command unknown-arg"]) end) == help_output()
  end

  def help_output do
    "\n\e[1mGLAYU COMMANDS\n\e[0m\nglayu \e[0m\e[96minit \e[0m[\e[1mfolder\e[0m]               Initializes the website.\n\nglayu \e[0m\e[96mnew \e[0m[\e[1mfolder\e[0m] <\e[1mtitle\e[0m>        Creates a new post or page.\n\nglayu \e[0m\e[96mpublish \e[0m<\e[1mfilename\e[0m>          Publishes a draft.\n\nglayu \e[0m\e[96mbuild \e[0m[\e[1m-chp\e[0m] [\e[1mregex\e[0m]        Generates the static files.\n\nglayu \e[0m\e[96mhelp \e[0m[\e[1mcommand\e[0m]              Displays help.\n\n\e[0m\n"
  end

end