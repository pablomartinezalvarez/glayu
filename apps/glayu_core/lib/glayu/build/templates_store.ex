defmodule Glayu.Build.TemplatesStore do

  @name :templates_store

  def start_link do
    Agent.start_link(fn -> [] end, name: @name)
  end

  def add_templates(templates) do
    Agent.update(@name, fn _ ->
      templates
    end)
  end

  def get_layout(layout) do
    Agent.get(@name, fn tpls -> tpls[:layouts][layout] end)
  end

  def get_partial(partial) do
    Agent.get(@name, fn tpls -> tpls[:partials][partial] end)
  end

end