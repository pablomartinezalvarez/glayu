defmodule Glayu.CLI.NewTest do

  use ExUnit.Case
  import ExUnit.CaptureIO

  test "new command help is displayed when invalid arguments are provided" do
    assert capture_io(fn ->  Glayu.CLI.main(["new", "New Glayu Post", "invalid-arg"]) end) == help_output()
  end

  test "new page command help is displayed when invalid arguments are provided" do
    assert capture_io(fn ->  Glayu.CLI.main(["new", "page", "New Glayu Post", "invalid-arg"]) end) == help_output()
  end

  def help_output do
    "\nglayu \e[0m\e[96mnew \e[0m[\e[1mfolder\e[0m] <\e[1mtitle\e[0m>\n\nCreates a new post or page.\n\nAll new posts are considered drafts and will be placed under the \e[1msource/_drafts\e[0m directory, this directory will be skipped during a site build. When a post is ready it can be published using the \e[1mpublish\e[0m command.\n\nAll pages are placed under the \e[1msource\e[0m directory, and are rendered during a site build.\n\n\e[1mARGUMENTS\n\e[0m\n[\e[1mlayout\e[0m]\n\e[1mpost\e[0m or \e[1mpage\e[0m. If no layout is provided, Glayu will use the post layout.\n\n<\e[1mtitle\e[0m>\nArticle title. If the title contains spaces, surround it with quotation marks.\n\n\n"
  end

end
