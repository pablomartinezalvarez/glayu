defmodule Glayu.ConfigStore do

  alias Glayu.Utils.Yaml

  @moduledoc """
  Site Configuration Store
  """

  @name :config_store

  def start_link do
    Agent.start_link(fn -> [] end, name: @name)
  end

  def reset do
    Agent.update(@name, fn _ ->
      []
    end)
  end

  def set_config(yaml_doc) do
    Agent.update(@name, fn _ ->
      yaml_doc
    end)
  end

  def get(key) do
    Agent.get(@name, fn yaml_doc ->
      Yaml.get_string_value(yaml_doc, key)
    end)
  end

  def empty? do
    Agent.get(@name, fn yaml_doc ->
      Enum.empty?(yaml_doc)
     end)
  end

end