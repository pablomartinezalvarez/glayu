defmodule Glayu.Templates.Config do
  def tpl do
    """
    # Glayu Configuration

    # Site
    title: A brand new static site              # Site Title

    # URL
    permalink: categories/year/month/day/title  # Permalink format

    # Directories
    source_dir: source                          # Source folder
    public_dir: public                          # Destination folder

    # Theme
    theme: glayu-times                          # Selected Theme under themes dir
    """
  end
end