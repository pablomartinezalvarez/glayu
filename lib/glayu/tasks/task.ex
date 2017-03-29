defmodule Glayu.Tasks.Task do

	@callback run(Keyword.t) :: {:ok, String.t} | {:error, String.t}

end