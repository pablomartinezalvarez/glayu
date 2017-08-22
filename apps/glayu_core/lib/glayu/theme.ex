defmodule Glayu.Theme do

  require Logger

  @user_agent [ {"User-agent", "Glayu static site generator"} ]
  @zip_ext ".zip"

  @moduledoc """
  Downloads and extracts remote themes.
  """

  @doc """
  Downloads a theme from the provided `uri` and extracts its content under your site `themes` directory using the name provided on `theme`
  * `theme` theme name
  * `uri` uri where the theme is hosted
  Returns `:ok` if successful, `{:error, reason} otherwise.
  """
  @spec download_theme(String.t, String.t) :: :ok | {:error, any}
  def download_theme(theme, uri) do
    path = Glayu.Path.theme_dir(theme)
    if File.dir?(path) do
      :ok
    else
      saved = save_theme(HTTPoison.get(uri, @user_agent), path)
      case saved do
        :ok ->
          unzip_theme(path)
        {:error, reason} ->
          {:error, reason}
      end
    end
  end

  defp save_theme({ :ok, %{status_code: 200, body: body, headers: _}}, path) do
    File.write!(path <> @zip_ext, body)
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
      {:error, "Unable to download theme."}
    end
  end

  defp save_theme({ _, %{status_code: _, body: _, headers: _}}, _) do
     {:error, "Unable to download theme."}
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
      {:error, "Invalid theme."}
    end
  end

end