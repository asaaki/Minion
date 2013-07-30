defmodule Minion do
  use Application.Behaviour

  def start(_type, _args) do
    Minion.Supervisor.start_link
  end

  def stop(_type) do
    # implement shutdown
  end

  def all do
  	[Node.self | Node.list]
  end
  
  def me do
  	Node.self
  end

  def other do
  	Node.list
  end

  def execute nodes, module, function, args do
    if length(nodes) > 0 do
      [head|rest] = nodes

      execute rest, module, function, args

      Node.spawn(head, module, function, args)
    end

    :ok
  end
end
