defmodule Glayu.Theme do

  require Logger

  @user_agent [ {"User-agent", "Glayu static site generator"} ]
  @zip_ext ".zip"

  def download_theme(theme, uri) do
    path = Glayu.Path.theme_dir(theme)
    unless File.dir?(path) do
      uri
      |> HTTPoison.get(@user_agent)
      |> save_theme(path)
      |> unzip_theme
    end
  end

  defp save_theme({ :ok, %{status_code: 200, body: body, headers: _}}, path) do
    File.write!(path <> @zip_ext, body)
    path
  end

  # Try to handle redirects
  defp save_theme({ _, %{status_code: 302, body: _, headers: headers}}, path) do
    found = List.keyfind(headers, "Location", 0)

    if found do
      {_, uri} = found
      uri
      |> HTTPoison.get(@user_agent)
      |> save_theme(path)

    else
      raise "Unable to download theme."
    end
  end

  defp save_theme({ _, %{status_code: _, body: _, headers: _}}, _) do
     raise "Unable to download theme."
  end

  defp unzip_theme(path) do
    {:ok, files} = :zip.unzip(String.to_char_list(path <> @zip_ext), [{:cwd, String.to_char_list(Glayu.Path.themes_dir())}])
    rename_theme_dir(files, path)
  end

  defp rename_theme_dir(files, path) do
    layout = Enum.find(files, fn(file) -> Path.basename(file) == "layout.eex" end)

    if layout do
      current_path = String.replace_suffix(to_string(layout), "/_layouts/layout.eex", "")
      if current_path != path do
        File.rename(current_path, path)
      end
    else
      raise "Invalid theme."
    end
  end

end