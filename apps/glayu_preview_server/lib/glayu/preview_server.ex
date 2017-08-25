defmodule Glayu.PreviewServer do

  use Application

  def start(_type, args) do
    Glayu.PreviewServer.Supervisor.start_link(args)
  end

end
