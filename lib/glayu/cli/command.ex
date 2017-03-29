defmodule Glayu.CLI.Command do

	@callback help :: String.t

	@callback run(Keyword.t) :: {:ok, String.t} | {:error, String.t}

end