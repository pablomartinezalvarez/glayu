defmodule Glayu.SiteChecker do

  @category_layout "category"
  @home_layout "home"
  @main_layout "layout"
  @page_layout "page"
  @post_layout "post"

  defmodule InvalidSiteError do

    @moduledoc """
    Exception raised when the site workspace doesn't have the required structure.
    """

    defexception [:reason]

    def message(exception) do
      "Invalid Site: " <> exception.reason
    end

  end

  def check_site! do
    exists!(Glayu.Path.source_root())
    exists!(Glayu.Path.source_root(:post))
    exists!(Glayu.Path.source_root(:draft))
    exists!(Glayu.Path.themes_dir())
  end

  def check_theme! do
    exists!(Glayu.Path.active_theme_dir())
    exists!(Glayu.Path.layouts_dir())
    exists!(Glayu.Path.layout(@category_layout))
    exists!(Glayu.Path.layout(@home_layout))
    exists!(Glayu.Path.layout(@main_layout))
    exists!(Glayu.Path.layout(@page_layout))
    exists!(Glayu.Path.layout(@post_layout))
  end

  defp exists!(path) do
    unless File.exists?(path) do
      raise InvalidSiteError, reason: path <> " does not exists"
    end
    :ok
  end

end