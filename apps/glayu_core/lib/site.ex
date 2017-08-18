defmodule Glayu.Site do

  alias Glayu.Config

  def context do
    %{title: to_string(Config.get('title'))}
  end

end