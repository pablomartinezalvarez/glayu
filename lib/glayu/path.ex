defmodule Glayu.Path do

  @drafts_dir "_drafts"
  @posts_dir "_posts"
  @themes_dir "themes"
  @layouts_dir "_layouts"
  @partials_dir "_partials"
  @assets_dir "assets"
  @config_file "_config.yml"
  @index "index"
  @md_ext ".md"
  @html_ext ".html"
  @eex_ext ".eex"

  alias Glayu.Slugger
  alias Glayu.Config

  def source_from_title(title, :page) do
    slug = Slugger.slug(title)
    if slug != "" do
     {:ok, Path.join(source_root(), slug <> @md_ext)}
    else
     {:error, "Invalid title"}
    end
  end

  def source_from_title(title, :draft) do
    slug = Slugger.slug(title)
    if slug != "" do
      {:ok, Path.join(source_root(:draft), Slugger.slug(title) <> @md_ext)}
    else
      {:error, "Invalid title"}
    end
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

  def category_source_dir(keys) do
    Path.join([source_root(:post)] ++ keys)
  end

  def category_dir(keys) do
    Path.join([public_root()] ++ keys)
  end

  def category_page(keys) do
    Path.join(category_dir(keys), @index <> @html_ext)
  end

  def base_dir() do
    Path.absname(Config.get('base_dir'))
  end

  def site_config() do
    Path.absname(Path.join(Config.get('base_dir'), @config_file))
  end

  def source_root() do
    Path.absname(Path.join(Config.get('base_dir'), Config.get('source_dir')))
  end

  def home_page() do
    Path.join(public_root(), @index <> @html_ext)
  end

  def public_root() do
    Path.absname(Path.join(Config.get('base_dir'), Config.get('public_dir')))
  end

  def source_root(:post) do
    Path.absname(Path.join([Config.get('base_dir'), Config.get('source_dir'), @posts_dir]))
  end

  def source_root(:draft) do
    Path.absname(Path.join([Config.get('base_dir'), Config.get('source_dir'), @drafts_dir]))
  end

  def themes_dir do
    Path.absname(Path.join([Config.get('base_dir'), @themes_dir]))
  end

  def theme_dir(name) do
    Path.absname(Path.join([Config.get('base_dir'), @themes_dir, name]))
  end

  def layout(template) do
    Path.absname(Path.join([Config.get('base_dir'), @themes_dir, Config.get('theme'), @layouts_dir, template <> @eex_ext]))
  end

  def partials_dir() do
    Path.absname(Path.join([Config.get('base_dir'), @themes_dir, Config.get('theme'), @partials_dir]))
  end

  def layouts_dir() do
    Path.absname(Path.join([Config.get('base_dir'), @themes_dir, Config.get('theme'), @layouts_dir]))
  end

  def assets_source() do
    Path.absname(Path.join([Config.get('base_dir'), @themes_dir, Config.get('theme'), @assets_dir]))
  end

  def public_assets() do
    Path.absname(Path.join([Config.get('base_dir'), Config.get('public_dir'), @assets_dir]))
  end

end