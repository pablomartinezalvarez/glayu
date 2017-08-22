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
      "glayu ", :reset, :light_cyan, "build ", :reset, "[", :bright, "-chp", :reset, "] [", :bright, "regex", :reset, "]\n",
      "\n",
      "Generates the static files.\n",
      "\n",
      :bright, "ARGUMENTS\n", :reset,
      "\n",
      "[", :bright, "regex", :reset, "]\n",
      "If provided, only the pages under the directories matching the regex will be generated. The regular expression is based on PCRE (Perl Compatible Regular Expressions)\n",
      "\n",
      :bright, "OPTIONS\n", :reset,
      "\n",
      "If one of the ", :bright, "-chp", :reset," options is provided the building process will consider only the resource types provided on the options.\n",
      "\n",
      "[", :bright, "-c", :reset, ",", :bright," --categories", :reset, "]\n",
      "Adds category pages to the building pipeline.\n",
      "\n",
      "[", :bright, "-h", :reset, ",", :bright," --home", :reset, "]\n",
      "Adds home page to the building pipeline.\n",
      "\n",
      "[", :bright, "-p", :reset, ",", :bright," --pages", :reset, "]\n",
      "Adds post and pages to the building pipeline.\n",
      "\n"
    ])
  end

  def run(params) do

    Application.start(:glayu_build)

    Keyword.merge([regex: List.first(params[:args])], params[:opts])
    |> Build.run
    |> handle_result

  end

  defp handle_result({:ok, results}) when results > 0 do
    {:ok, IO.ANSI.format(["🐦  ", :light_cyan, "Site Generated Successfully in #{results} seconds.", :reset])}
  end

  defp handle_result({:ok, _}) do
    {:ok, IO.ANSI.format(["🐦  ", :light_cyan, "Site Generated Successfully.", :reset])}
  end

  defp handle_result({status, results}) do
    {status, results}
  end

end