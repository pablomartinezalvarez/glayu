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
    IO.ANSI.format(["\n",
      "glayu ", IO.ANSI.reset, IO.ANSI.light_cyan, "build ", IO.ANSI.reset, "[", IO.ANSI.bright, "-chp", IO.ANSI.reset, "] [", IO.ANSI.bright, "regex", IO.ANSI.reset, "]\n",
      "\n",
      "Generates the static files.\n",
      "\n",
      IO.ANSI.bright, "ARGUMENTS\n", IO.ANSI.reset,
      "\n",
      "[", IO.ANSI.bright, "regex", IO.ANSI.reset, "]\n",
      "If provided, only the pages under the directories matching the regex will be generated. The regular expression is based on PCRE (Perl Compatible Regular Expressions)\n",
      "\n",
      IO.ANSI.bright, "OPTIONS\n", IO.ANSI.reset,
      "\n",
      "If one of the ", IO.ANSI.bright, "-chp", IO.ANSI.reset," options is provided the building process will consider only the resource types provided on the options.\n",
      "\n",
      "[", IO.ANSI.bright, "-c", IO.ANSI.reset, ",", IO.ANSI.bright," --categories", IO.ANSI.reset, "]\n",
      "Adds category pages to the building pipeline.\n",
      "\n",
      "[", IO.ANSI.bright, "-h", IO.ANSI.reset, ",", IO.ANSI.bright," --home", IO.ANSI.reset, "]\n",
      "Adds home page to the building pipeline.\n",
      "\n",
      "[", IO.ANSI.bright, "-p", IO.ANSI.reset, ",", IO.ANSI.bright," --pages", IO.ANSI.reset, "]\n",
      "Adds post and pages to the building pipeline.\n",
      "\n"
    ])
  end

  def run(params) do

    Application.start(:glayu_build)

  	{status, results} = Build.run Keyword.merge([regex: List.first(params[:args])], params[:opts])

  	if status == :ok do
  	  if results > 0 do
  	    {:ok, IO.ANSI.format(["🐦  ", IO.ANSI.light_cyan, "Site Generated Successfully in #{results} seconds.", IO.ANSI.reset])}
  	  else
  	    {:ok, IO.ANSI.format(["🐦  ", IO.ANSI.light_cyan, "Site Generated Successfully.", IO.ANSI.reset])}
  	  end
  	else
  	  {status, results}
  	end
  end

end