defmodule Minion do
  use Application.Behaviour

  def start(_type, args) do
    Minion.Supervisor.start_link
  end

  def stop(_type) do
    # implement shutdown
  end
end
