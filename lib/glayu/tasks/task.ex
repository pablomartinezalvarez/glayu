defmodule Glayu.Tasks.Task do

  @callback run(Keyword.t) :: {:ok, any} | {:error, any}

end