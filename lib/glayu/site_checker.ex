defmodule Glayu.SiteChecker do

  defmodule InvalidSiteError do

    @moduledoc """
    Exception raised when the site workspace doesn't have the required structure.
    """

    defexception [:reason]

    def message(exception) do
      "Invalid Site: " <> exception.reason <>
      "\n please run the 'glayu init' command to initialize this site."
    end

  end

  def check! do
    exists!(Glayu.Path.source_root())
    exists!(Glayu.Path.source_root(:post))
    exists!(Glayu.Path.source_root(:draft))
    exists!(Glayu.Path.themes_dir())
  end

  defp exists!(path) do
    unless File.exists?(path) do
      raise InvalidSiteError, reason: path <> " does not exists"
    end
    :ok
  end

end