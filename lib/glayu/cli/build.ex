defmodule Glayu.CLI.Build do

  @behaviour Glayu.CLI.Command

  alias Glayu.Tasks.Build

  def options do
    [
      categories: :boolean,
      home: :boolean,
      pages: :boolean
    ]
  end

  def aliases do
    [
      c: :categories,
      h: :home,
      p: :pages
    ]
  end

  def help do
    """
    glayu build [-chp] [regex]

    Generates static files.

    ARGUMENTS

    [regex]

    If provided, only the pages under the directories matching the regex will be generated. The regular expression is based on PCRE (Perl Compatible Regular Expressions)

    OPTIONS

    If one of the `-chp` options is provided the building process will consider only the resource types provided on the options.

    [-c, --categories]
    Add category pages to the building pipeline.

    [-h, --home]
    Add home page to the building pipeline.

    [-p, --pages]
    Add post and pages to the building pipeline.
    """
  end

  def run(params) do
  	{status, results} = Build.run Keyword.merge([regex: List.first(params[:args])], params[:opts])
  	if status == :ok do
  	  {:ok, IO.ANSI.format(["🐦  ", :light_cyan, "Site Generated Successfully"])}
  	else
  	  {status, results}
  	end
  end




end