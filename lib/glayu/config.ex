defmodule Glayu.Config do

  alias Glayu.Utils.Yaml
  alias Glayu.Validator

  def load_config do
    if Glayu.ConfigStore.empty? do
      load_config_file("./_config.yml")
    end
  end

  def load_config(dir) do
    load_config_file(Path.join(dir, "_config.yml"))
  end

  def get(key) do
    Glayu.ConfigStore.get(key)
  end

  defp load_config_file(path) do
    if File.exists? path do
      yaml_doc = List.flatten(:yamerl_constr.file(path)) ++ [{'base_dir', to_charlist(Path.dirname(path))}]
      validate_config(yaml_doc)
      Glayu.ConfigStore.set_config(yaml_doc)
    else
      raise "_config.yml file not found"
    end
  end

  defp validate_config(yaml_doc) do

    validate(yaml_doc, 'title', [Validator.yml_required])
    validate(yaml_doc, 'permalink', [Validator.yml_required, Validator.permalink_conf])
    validate(yaml_doc, 'source_dir', [Validator.yml_required])
    validate(yaml_doc, 'public_dir', [Validator.yml_required])
    validate(yaml_doc, 'theme', [Validator.yml_required])
    validate(yaml_doc, 'theme_uri', [Validator.uri])

  end

  defp validate(yaml_doc, field, validators) do
    value = Yaml.get_string_value(yaml_doc, field)
    if value || Enum.member?(validators, Validator.yml_required) do
      result = Saul.validate(value, Saul.all_of(validators))
      case result do
        {:error, resume} ->
          raise "Ivalid _config.yml file, field " <> to_string(field) <> ": " <> resume.reason
        _ -> :ok
      end
    end
  end

end