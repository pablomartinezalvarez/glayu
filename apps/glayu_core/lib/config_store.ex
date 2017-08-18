defmodule Glayu.ConfigStore do

  alias Glayu.Utils.Yaml

  @moduledoc """
  Site Configuration Store
  """

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def reset do
    Agent.update(__MODULE__, fn _ ->
      []
    end)
  end

  def set_config(yaml_doc) do
    Agent.update(__MODULE__, fn _ ->
      yaml_doc
    end)
  end

  def get(key) do
    Agent.get(__MODULE__, fn yaml_doc ->
      Yaml.get_string_value(yaml_doc, key)
    end)
  end

  def empty? do
    Agent.get(__MODULE__, fn yaml_doc ->
      Enum.empty?(yaml_doc)
     end)
  end

end