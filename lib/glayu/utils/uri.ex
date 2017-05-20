defmodule Glayu.Utils.URI do

  def valid_uri?(str) do
    uri = URI.parse(str)
    case uri do
      %URI{scheme: nil} -> false
      %URI{host: nil} -> false
      %URI{path: nil} -> false
      uri -> true
    end
  end

end