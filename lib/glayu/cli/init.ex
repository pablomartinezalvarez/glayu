defmodule Glayu.CLI.Init do

  alias Glayu.Tasks.Init

  def options do
    []
  end

  def aliases do
    []
  end

  def run(params) do
  	params |> Init.run
  end

end