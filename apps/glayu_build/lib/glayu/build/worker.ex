defmodule Glayu.Build.Worker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({job, node, args}, _from, state) do
    try do
      {:reply, job.run(node, args), state}
    rescue error ->
      exit {:shutdown, error}
    catch _, error ->
      exit {:shutdown, error}
    end
  end

end
