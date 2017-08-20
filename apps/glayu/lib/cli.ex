defmodule Glayu.CLI do

  alias Glayu.CLI.Utils

  @commands ["init", "new", "publish", "build", "serve", "help"]

  def commands do
    @commands
  end

  def main(args) do
    args
    |> parse_args
    |> run
    |> print_result
  end

  defp parse_args([]) do
    :unknown
  end

  defp parse_args([command | opts]) do
    if Enum.member?(@commands, command) do
      module = Utils.get_command_module(command)
      options = apply(module, :options, [])
      aliases = apply(module, :aliases, [])
      parse = OptionParser.parse(opts, strict: options, aliases: aliases)
      case parse do
        {opts, args, []} -> {:ok, command, [opts: opts, args: args]}
        {opts, args, error} -> {:error, command, [opts: opts, args: args, error: error]}
      end
    else
      :unknown
    end
  end

  defp run({:ok, command, params}) do
    try do
      apply(Utils.get_command_module(command), :run, [params])
    rescue error ->
      {:error, Exception.message(error)}
    catch error ->
      {:error, "#{inspect error}"}
    end
  end

  defp run(:unknown) do
    Glayu.CLI.Help.run([])
  end

  defp run({:error, _, _}) do
    Glayu.CLI.Help.run([])
  end

  defp print_result({:ok, info}) do
    IO.puts info
  end

  defp print_result({:error, info}) do
    IO.puts IO.ANSI.format(["💣  ", :red, info], true)
  end

end
    