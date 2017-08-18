defmodule Glayu.CLI.InitTest do

  use ExUnit.Case
  import ExUnit.CaptureIO

  test "init command help is displayed when invalid arguments are provided" do
    assert capture_io(fn ->  Glayu.CLI.main(["init", "/my-web-site-dir", "invalid-arg"]) end) == help_output()
  end

  def help_output do
    "\nglayu \e[0m\e[96minit \e[0m[\e[1mfolder\e[0m]\n\nInitializes the website.\n\nIf no \e[1mfolder\e[0m is provided, the website will be configured in the current directory. If the destination folder exists and contains a \e[1m_config.yml\e[0m file, this configuration file will be used to initialize the site.\n\n\e[1mARGUMENTS\n\e[0m\n[\e[1mfolder\e[0m]\nWebsite destination folder. If the destination folder doesn't exists the full path to it will be created.\n\n\n"
  end

end