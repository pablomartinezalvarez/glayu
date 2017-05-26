defmodule Glayu.Tasks.Publish do

  @yes ["y", "yes", "yea", "affirmative", "ok", "okay"]
  @no ["n", "no", "not", "nix", "negative", "never", "no way"]

  @behaviour Glayu.Tasks.Task

  def run(params) do

    Glayu.Config.load_config()

    file_path = normalize_file_path(params[:filename])

    file_path
    |> parse_draft
    |> create_destination_dir
    |> mv_draft(file_path)

  end

  defp normalize_file_path(filename) do
    if length(Path.split(filename)) == 1 do
      Glayu.Path.source_from_file_name(filename, :draft)
    else
      filename
    end
  end

  defp parse_draft(filename) do
    Glayu.Document.parse(filename)
  end

  defp create_destination_dir(doc_context) do
    doc_context
    |> Glayu.Permalink.from_context
    |> Glayu.Path.source_dir_from_permalink(:post)
    |> File.mkdir_p!
    doc_context
  end

  defp mv_draft(doc_context, source) do
    destination = Glayu.Path.source_from_permalink(Glayu.Permalink.from_context(doc_context), :post)
    if !File.exists?(destination) || override?(destination, nil) do
      :ok = File.rename(source, destination)
      {:ok, %{status: :published, path: destination}}
    else
      {:ok, %{status: :canceled, path: destination}}
    end
  end

  defp override?(path, previous_answer) do
    answer = override_question(path, previous_answer)
    cond do
      Enum.member?(@yes, String.trim(String.downcase(answer))) -> true
      Enum.member?(@no, String.trim(String.downcase(answer))) -> false
      true -> override?(path, :invalid)
    end
  end

  defp override_question(_, :invalid) do
    IO.gets(IO.ANSI.format(["Please use ", :light_cyan, "yes", :reset, " or ", :light_cyan, "no\n"]))
  end

  defp override_question(path, _) do
    IO.puts(IO.ANSI.format([:yellow, "⚠️  Destination file ", :bright, Path.absname(path), :normal, " already exists"]))
    IO.gets("Whould you like to override it? ")
  end

end