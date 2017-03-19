defmodule Glayu.CLI.Init do

  alias Glayu.Tasks.Init

  def options do
    []
  end

  def aliases do
    []
  end

  def help do
    """
    glayu init [folder]

    Initializes the web site. If no root folder is provided the current directory will be the site root folder
    """
  end

  def run(params) do
    (List.first(params[:args]) || ".") # The directory is the first argument
  	|> Init.run
  end

end