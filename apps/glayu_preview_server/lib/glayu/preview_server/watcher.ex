defmodule Glayu.PreviewServer.Watcher do

  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  ## Server Callbacks

  def init(args) do
    {:ok, watcher_pid} = FileSystem.start_link(args)
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid}=state) do
    Logger.info(IO.ANSI.format([:bright, "#{path}", :reset, " was", print_events(events)]))

    if String.starts_with?(path, Glayu.Path.active_theme_dir()) do
      Logger.info("Recompiling theme templates...")
      Glayu.Build.TemplatesStore.add_templates(Glayu.Template.compile())
    end

    if String.starts_with?(path, Glayu.Path.source_root()) do
      Glayu.Build.SiteTree.reset()
      {status, info} = Glayu.Tasks.Build.run_task(:scan, [])

      if status == :error do
        IO.puts IO.ANSI.format(["💣  ", :red, info], true)
      end
    end

    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid}=state) do
    Logger.info("Stopping preview server life reloader.")
    {:noreply, state}
  end

  ## Private Methods

  defp print_events(events) do
    Enum.map(events, fn(event) -> [" ", :bright, to_string(event), :reset] end)
  end

end