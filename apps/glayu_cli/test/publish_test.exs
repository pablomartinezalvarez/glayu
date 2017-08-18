defmodule Glayu.CLI.PublishTest do

  use ExUnit.Case
  import ExUnit.CaptureIO

  test "publish command help is displayed when invalid arguments are provided" do
    assert capture_io(fn ->  Glayu.CLI.main(["publish", "my-draft.md", "invalid-arg"]) end) == help_output()
  end

  def help_output do
    "\nglayu \e[0m\e[96mpublish \e[0m<\e[1mfilename\e[0m>\n\nPublishes a draft.\n\nThe markdown file will be moved from the \e[1msource/_drafts\e[0m directory to a directory under \e[1msource/_posts\e[0m following the permalik definition provided in \e[1m_config.yml\n\e[0m\n\e[1mARGUMENTS\n\e[0m\n<\e[1mfilename\e[0m>\nMarkdown source file. The file name or the file path can be provided.\n\n\n"
  end

end