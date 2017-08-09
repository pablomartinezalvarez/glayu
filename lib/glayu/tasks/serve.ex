defmodule Glayu.Tasks.Serve do

  @behaviour Glayu.Tasks.Task

  def run(params) do

    Application.start(:cowboy)
    Application.start(:plug)

    Glayu.Config.load_config()
    Glayu.SiteChecker.check_site!()
    {:ok, _} = Glayu.PreviewServer.Supervisor.start_link(params)

    Glayu.Build.TemplatesStore.add_templates(Glayu.Template.compile())
    {status, info} = Glayu.Tasks.Build.run_task(:scan, [])

    if status == :error do
      IO.puts IO.ANSI.format(["💣  ", :red, info], true)
    end

    ["🐦  Preview server started at port ", :light_cyan, "http://localhost:#{params[:port]}/"]
    |> IO.ANSI.format
    |> IO.puts

    :timer.sleep(:infinity)

  end

end