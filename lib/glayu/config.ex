defmodule Glayu.Config do

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
      List.flatten(:yamerl_constr.file(path)) ++ [{'base_dir', to_charlist(Path.dirname(path))}]
      |> validate_config!
      |> Glayu.ConfigStore.set_config
    else
      raise "_config.yml file not found"
    end
  end

  defp validate_config!(yaml_doc) do

   validators = [
     {'title', [Glayu.Validations.RequiredValidator.validator()]},
     {'source_dir', [Glayu.Validations.RequiredValidator.validator()]},
     {'public_dir', [Glayu.Validations.RequiredValidator.validator()]},
     {'permalink', [Glayu.Validations.RequiredValidator.validator(), Glayu.Validations.PermalinkConfValidator.validator()]},
     {'theme', [Glayu.Validations.RequiredValidator.validator()]},
     {'theme_uri', [Glayu.Validations.URIValidator.validator()]}
   ]

   Glayu.Validations.Validator.validate!(yaml_doc, validators, fn (source, field) ->
     Glayu.Utils.Yaml.get_string_value(source, field)
   end)

  end

end