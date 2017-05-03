defmodule Glayu.Path do

  @drafts_dir "_drafts"
  @posts_dir "_posts"
  @themes_dir "themes"
  @layouts_dir "_layouts"
  @partials_dir "_partials"
  @assets_dir "assets"
  @md_ext ".md"
  @html_ext ".html"
  @eex_ext ".eex"

  alias Glayu.Slugger
  alias Glayu.Config

  def source_from_title(title, :page) do
    Path.join(source_root(), Slugger.slug(title) <> @md_ext)
  end

  def source_from_title(title, :draft) do
    Path.join(source_root(:draft), Slugger.slug(title) <> @md_ext)
  end

  def source_from_file_name(file_name, :page) do
    Path.join(source_root(), file_name)
  end

  def source_from_file_name(file_name, :draft) do
    Path.join(source_root(:draft), file_name)
  end

  def source_dir_from_permalink(permalink, :page) do
    Path.join([source_root()] ++ Enum.drop(permalink, -1))
  end

  def source_dir_from_permalink(permalink, :post) do
    Path.join([source_root(:post)] ++ Enum.drop(permalink, -1))
  end

  def source_from_permalink(permalink, type) do
    file_name = List.last(permalink)
    Path.join(source_dir_from_permalink(permalink, type), file_name <> @md_ext)
  end

  def public_dir_from_permalink(permalink) do
    Path.join([public_root()] ++ Enum.drop(permalink, -1))
  end

  def public_from_permalink(permalink) do
    file_name = List.last(permalink)
    Path.join(public_dir_from_permalink(permalink), file_name <> @html_ext)
  end

  def source_root() do
    Path.absname(Path.join(".", to_string(Config.get('source_dir'))))
  end

  def public_root() do
    Path.absname(Path.join(".", to_string(Config.get('public_dir'))))
  end

  def source_root(:post) do
    Path.absname(Path.join([".", to_string(Config.get('source_dir')), @posts_dir]))
  end

  def source_root(:draft) do
    Path.absname(Path.join([".", to_string(Config.get('source_dir')), @drafts_dir]))
  end

  def layout(template) do
    Path.absname(Path.join([".", @themes_dir, to_string(Config.get('theme')), @layouts_dir, template <> @eex_ext ]))
  end

  def partials_dir() do
    Path.absname(Path.join([".", @themes_dir, to_string(Config.get('theme')), @partials_dir]))
  end

  def layouts_dir() do
    Path.absname(Path.join([".", @themes_dir, to_string(Config.get('theme')), @layouts_dir]))
  end

  def assets_source() do
    Path.absname(Path.join([".", @themes_dir, to_string(Config.get('theme')), @assets_dir]))
  end

  def public_assets() do
    Path.absname(Path.join([".", to_string(Config.get('public_dir')), @assets_dir]))
  end

end