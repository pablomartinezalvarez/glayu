defmodule Glayu.Tasks.Serve do

  @behaviour Glayu.Tasks.Task

  def run(params) do

    Glayu.Config.load_config()
    Glayu.SiteChecker.check_site!()

    Application.start(:glayu_build)
    Glayu.Build.TemplatesStore.add_templates(Glayu.Template.compile())
    {status, info} = Glayu.Tasks.Build.run_task(:scan, [])
    if status == :error do
      IO.puts IO.ANSI.format(["💣  ", :red, info], true)
    end

    Application.put_env(:glayu_preview_server, :args, params)
    Application.start(:glayu_preview_server)

    :timer.sleep(:infinity)

  end

end