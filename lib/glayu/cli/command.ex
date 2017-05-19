defmodule Glayu.CLI.Command do

  @callback aliases :: List.t

  @callback options :: List.t

  @callback help :: String.t

  @callback run(Keyword.t) :: {:ok, String.t} | {:error, String.t}

end