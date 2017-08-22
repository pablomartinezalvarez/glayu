defmodule Glayu.Build do

  use Application

  def start(_type, _args) do
    Glayu.Build.Supervisor.start_link
  end

end
