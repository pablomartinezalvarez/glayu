defmodule Glayu.CLI.Serve do

  @behaviour Glayu.CLI.Command

  alias Glayu.Tasks.Serve

  def options do
    []
  end

  def aliases do
    []
  end

  def help do
    IO.ANSI.format(["\n",
      "glayu ", IO.ANSI.reset, IO.ANSI.light_cyan(), "serve ", IO.ANSI.reset, "[", IO.ANSI.bright, "port", IO.ANSI.reset, "]\n",
      "\n",
      "Starts the preview server at ", IO.ANSI.bright, "http://localhost:4000", IO.ANSI.reset, "\n",
      "\n",
      IO.ANSI.bright, "ARGUMENTS\n", IO.ANSI.reset,
      "\n",
      "[", IO.ANSI.bright, "port", IO.ANSI.reset, "]\n",
      "Alternative server port.\n",
      "\n"
    ])
  end

  def run(params) do

  {status, args} = parse_args(params[:args])

  if status == :ok do

    Application.start(:glayu_build)
    Application.start(:glayu_preview_server)

    Serve.run(args)
  else
    {:ok, help()}
  end

  end

  defp parse_args([]) do
    {:ok, [port: 4000]}
  end

  defp parse_args([port]) do
    {port_as_integer, _} = Integer.parse(port)
    {:ok, [port: port_as_integer]}
  end

  defp parse_args(_) do
    {:error, "Invalid number of arguments"}
  end

end