defmodule Minion.Supervisor do
  use Supervisor.Behaviour

  # A convenience to start the supervisor
  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  # The callback invoked when the supervisor starts
  def init(_) do
    children = [ worker(Minion.Worker, []) ]
    supervise children, strategy: :one_for_one
  end
end