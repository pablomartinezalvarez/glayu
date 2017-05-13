defmodule Glayu.Templates.Config do
  def tpl do
    """
    # Glayu Configuration

    # Site
    title: A brand new static site

    # URL
    permalink: categories/year/month/day/title

    # Directories
    source_dir: source
    public_dir: public

    # Theme
    theme: bootstrap
    """
  end
end