defmodule Glayu.PreviewServer.Plug.Server do

  use Plug.Builder

  @root "/"
  @index_page "/index.html"
  @assets_prefix "/assets/"
  @drafts_prefix "/_drafts/"
  @html_ext ".html"
  @md_ext ".md"

  plug :static_file
  plug :render_page
  plug :render_category
  plug :render_home
  plug :not_found

  def static_file(%Plug.Conn{request_path: path} = conn, _) do
    if String.starts_with?(path, @assets_prefix) do
      file_path = Path.join(Glayu.Path.active_theme_dir(), path)
      if File.exists?(file_path) do
        conn
        |> Plug.Conn.send_file(200, file_path)
        |> Plug.Conn.halt
      else
        conn
      end
    else
      conn
    end
  end

  def render_page(%Plug.Conn{request_path: path} = conn, _) do
    if String.ends_with?(path, @html_ext) do
      file_path = md_path(path)
      if file_path do
        html = file_path
          |> Glayu.Document.parse
          |> Glayu.Document.render
        conn
        |> send_resp(200, html)
        |> halt
      else
        conn
      end
    else
      conn
    end
  end

  def render_category(%Plug.Conn{request_path: path} = conn, _) do
    if String.ends_with?(path, [@root, @index_page]) && path != @root && path != @index_page do

      {_, keys} = path
        |> Path.dirname
        |> Path.split
        |> List.pop_at(0)

      if Glayu.Build.SiteTree.get_node(keys) do
        conn
        |> send_resp(200, Glayu.CategoryPage.render(keys))
        |> halt
      else
        conn
      end
    else
      conn
    end
  end

  def render_home(%Plug.Conn{request_path: path} = conn, _) do
    if path == @root || path == @index_page do
      conn
      |> send_resp(200, Glayu.HomePage.render())
      |> halt
    else
      conn
    end
  end

  def not_found(conn, _) do
    Plug.Conn.send_resp(conn, 404, "Resource not found")
  end

  defp md_path(path) do
    if String.starts_with?(path, @drafts_prefix) do
      draft_md_path(path)
    else
      post_md_path(path) || page_md_path(path)
    end
  end

  defp draft_md_path(path) do
    draft_path = path
      |> String.replace(@drafts_prefix, "")
      |> String.replace(@html_ext, @md_ext)

    existing_file(Path.join(Glayu.Path.source_root(:draft), draft_path))
  end

  defp post_md_path(path) do
    existing_file(Path.join(Glayu.Path.source_root(:post), String.replace(path, @html_ext, @md_ext)))
  end

  defp page_md_path(path) do
    existing_file(Path.join(Glayu.Path.source_root(), String.replace(path, @html_ext, @md_ext)))
  end

  defp existing_file(path) do
    if File.exists?(path) do
      path
    else
      nil
    end
  end

end