defmodule Glayu.HomePage do

  require EEx

  alias Glayu.Path
  alias Glayu.URL
  alias Glayu.Config

  def render(tpls) do
    page = %{title: to_string(Config.get('title')), layout: :home, path: URL.home()}
    Glayu.Template.render(:home, [page: page], tpls)
  end

  def write(html) do
    File.write!(Path.home_page(), html)
  end

end