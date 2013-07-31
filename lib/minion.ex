defmodule Minion do
  use Application.Behaviour

  @moduledoc """
  This module allows you to controll all your minions and make them execute commands.
  """


  def start(_type, _args) do
    Minion.Supervisor.start_link
  end

  def stop(_type) do
    # implement shutdown
  end

  @doc "Returns a list of all known minions including yourself"
  def all do
  	[Node.self | Node.list]
  end
  
  @doc "Returns yourself"
  def me do
  	Node.self
  end

  @doc "Returns a list of all known minions, but not yourself"
  def other do
  	Node.list
  end

  @doc "Returns a random Minion"
  def random do
    Random.sample(all)
  end

  @doc "Spawns a link on a random minion"
  def spawn_link function do
    Node.spawn_link random, function
  end

  @doc """
  Applys a function to all elements of a enumerable. Distributes over all known Minions

  ## Example

      Minion.perform_distributed [1,2,3,4,5,6,7,8], fn(x) -> IO.puts("Proudly processed by: #\{Minion.me\}"); x*x end
      #=> Proudly processed by: minion@MacBook-Air.local
      #=> Proudly processed by: minion@fennec.local
      #=> Proudly processed by: minion@raspberry.local
      #=> [1, 4, 9]

  """
  def perform_distributed enumerable, function do
    current = self

    enumerable |> Enum.map(fn(x) ->
      Minion.spawn_link(fn ->
        current <- { self, function.(x) } 
      end)
    end) |> Enum.map(fn(pid) ->
      receive do
        { ^pid, result } -> result
      end
    end)

  end

  @doc """
  Executes a function in a module. You can pass arguments, if the function does not require any arguments, pass [].

  It does not give you any output. But, the function you are calling could take a callback function that then processes its output.

  ## Simple Example

      Minion.execute [Minion.me], System, :cmd, ["uname -v"]
      #=> :ok


  ## Example with callback

      shell_command = "uname -v"
      complete = fn(node, result) ->
				IO.puts "\#{node} says: \#{result}"
      end
      Minion.execute(Minion.all, Cmd, :local, [shell_command, complete])
      #=> :ok
      #=> minion@MacBook-Air.local says: Darwin Kernel Version 12.4.0: Wed May  1 17:57:12 PDT 2013; root:xnu-2050.24.15~1/RELEASE_X86_64
      #=> minion@raspberry.local says: #1 PREEMPT Sun Jul 21 17:39:58 CDT 2013
  """
  def execute nodes, module, function, args do
    if length(nodes) > 0 do
      [head|rest] = nodes

      execute rest, module, function, args

      Node.spawn(head, module, function, args)
    end

    :ok
  end
end
