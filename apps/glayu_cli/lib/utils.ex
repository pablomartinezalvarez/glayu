defmodule Glayu.CLI.Utils do

  def get_command_module(command) do
    String.to_existing_atom("Elixir.Glayu.CLI." <> String.capitalize(command))
  end

end