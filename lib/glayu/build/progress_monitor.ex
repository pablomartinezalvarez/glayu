defmodule Glayu.Build.ProgressMonitor do

  def start_link do
    Agent.start_link(fn -> {0, 0} end, name: __MODULE__)
  end

  def add_files(num_files) do
    Agent.update(__MODULE__, fn {processed, total} ->
      total = total + num_files
      render_progress_bar(processed, total)
      {processed, total}
    end)
  end

  def inc_processed() do
    Agent.update(__MODULE__, fn {processed, total} ->
      processed = processed + 1
      render_progress_bar(processed, total)
      {processed, total}
    end)
  end

  defp render_progress_bar(processed, total) do
    format = [
      bar_color: [IO.ANSI.light_cyan_background],
      blank_color: [IO.ANSI.light_black_background],
      bar: " ",
      blank: " ",
      left: "Building site… |"
    ]
    ProgressBar.render(processed, total, format)
  end

end