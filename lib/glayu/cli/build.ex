defmodule Glayu.CLI.Build do

  @behaviour Glayu.CLI.Command

  alias Glayu.Tasks.Build

  def options do
    [full: :boolean]
  end

  def aliases do
    [f: :full]
  end

  def help do
    """
    glayu build [regex]

    Generates static pages

    Args:

    [regex]
    If provided, only the pages under the directories matching the regex will be generated. The regular expresion is based on PCRE (Perl Compatible Regular Expressions) 

    having the permalink option defined as follows on _config.yml: 

    permalink: category/year/month/day/title

    /software/.*2017/.*/01 will generate all the 2017 software posts published the first day of each month.

    """
  end

  def run(params) do
  	results = Build.run Keyword.merge([regex: List.first(params[:args])], params[:opts])
    build_result(results)
  end

  defp build_result({:ok, %{results: results}}) do
    {:ok, print_results(results, 0, 0, [])}
  end

  defp print_results([%Glayu.Build.Record{status: :ok, total_files: total_files}|more_results], num_nodes, total_gen, errors) do
    print_results(more_results, num_nodes + 1, total_gen + total_files, errors)
  end

  defp print_results([%Glayu.Build.Record{status: :error, node: node, total_files: total_files, details: details}|more_results], num_nodes, total_gen, errors) do
    error = [:red, :bright, "\n#{total_files}", :normal, " files ", :bright, "#{node}", :normal,  "\n#{inspect details}"]
    print_results(more_results, num_nodes, total_gen, [error|errors])
  end

  defp print_results([], num_nodes, total_gen, []) do
    IO.ANSI.format(["🐦  Build success: ", :light_cyan, "#{num_nodes}", :reset , " nodes processed, ", :light_cyan, "#{total_gen}", :reset , " pages generated."])
  end

  defp print_results([], num_nodes, total_gen, errors) do
    IO.ANSI.format([[:yellow, "\n⚠️  Build with errors: ", 
      :light_cyan, "#{num_nodes}", :reset , " nodes processed, ", :light_cyan, "#{total_gen}", :reset , " pages generated, ",
      :red, :bright, "#{length(errors)}", :normal , " nodes with errors.\nDetails:"] | errors])
  end

end