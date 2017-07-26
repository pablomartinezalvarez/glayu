defmodule GlayuApp do
  use Application

  def start(_type, _args) do
    Glayu.Supervisor.start_link
  end

end