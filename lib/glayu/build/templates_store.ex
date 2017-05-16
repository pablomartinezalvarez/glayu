defmodule Glayu.Build.TemplatesStore do

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def compile_templates do
    Agent.update(__MODULE__, fn _ ->
      Glayu.Template.compile()
    end)
  end

  def get_layout(layout) do
    Agent.get(__MODULE__, fn tpls -> tpls[:layouts][layout] end)
  end

  def get_partial(partial) do
    Agent.get(__MODULE__, fn tpls -> tpls[:partials][partial] end)
  end

end