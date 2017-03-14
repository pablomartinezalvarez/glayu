defmodule Glayu.CMD do
  @moduledoc """
  This module contains the entry point for the command line program
  (`Glayu.CMD.main/1`).
  """

  @doc "The entry point for Glayu command-line program."
  def main([]) do
    info()
    usage()
  end

  def main(args) do
    info()
    [task|opts] = args
    case task do
      "init" -> cmd_init opts
      "new" -> cmd_new opts
      "publish" -> cmd_publish opts
      "generate" -> cmd_generate opts
      "server" -> cmd_server opts
      "help" -> usage()
      _ -> usage()
    end
  end

  defp cmd_init(opts) do
    # TODO
  end

  defp cmd_new(opts) do
    # TODO
  end

  defp cmd_publish(opts) do
    # TODO
  end

  defp cmd_generate(opts) do
    # TODO
  end

  defp cmd_server(opts) do
    # TODO
  end

  def info() do
    IO.puts """
    \x1b[1mGlayu -- Yet another static site generator\x1b[0m
    """
  end

  defp usage() do
    IO.puts """
    Usage: glayu <task>
      Available Tasks:
      \x1b[96minit\x1b[0m TODO
      \x1b[96mnew\x1b[0m TODO
      \x1b[96mpublish\x1b[0m TODO
      \x1b[96mgenerate\x1b[0m TODO
      \x1b[96mserver\x1b[0m TODO
      \x1b[96mhelp\x1b[0m TODO
    """
  end

end
  