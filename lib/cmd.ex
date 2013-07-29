defmodule Cmd do
  @moduledoc """
  This module allows you to execute remote shell commands and get back the output.
  """

  @doc """
  Runs a shell command on all nodes including yourself

  ## Examples

      Cmd.all "uname -v"
      #=> #PID<0.101.0>
      #=> minion@MacBook-Air.local says: Darwin Kernel Version 12.4.0: Wed May  1 17:57:12 PDT 2013; root:xnu-2050.24.15~1/RELEASE_X86_64
      #=> minion@raspberry.local says: #1 PREEMPT Sun Jul 21 17:39:58 CDT 2013
  """
  def all command do
    all Node.self, command
  end

  @doc """
  Runs a shell command on all nodes including yourself and specifies a sender that gets back the output
  """
  def all sender, command do
    nodes = [Node.self | Node.list]
    execute sender, nodes, command
  end

  @doc "Executes command on all nodes except yourself"
  def other command do
    other Node.self, command
  end

  @doc "Executes command on all nodes except yourself and specifies a sender that gets back the output"
  def other sender, command do
    execute sender, Node.list, command
  end

  @doc "Executes command on all nodes except the given nodes"
  def except nodes, command do
    except Node.self, nodes, command
  end

  @doc "Executes command on all nodes except the given nodes and specifies a sender that gets back the output"
  def except sender, nodes, command do
    all_nodes = [Node.self | Node.list]

    Enum.each(all_nodes, fn(node) ->
      if !Enum.member?(nodes, node) do
        execute sender, [node], command
      end
    end)
  end

  @doc "Executes command only on the given nodes"
  def only nodes, command do
    only Node.self, nodes, command
  end

  @doc "Executes command only on the given nodes and specifies a sender that gets back the output"
  def only sender, nodes, command do
    execute sender, nodes, command
  end

  defp execute sender, list, command do
    if length(list) > 0 do
      [head|rest] = list

      execute sender, rest, command

      Node.spawn(head, Cmd, :local, [sender, command])
    end

    :ok
  end

  @doc """
  Runs a shell command on your current node and return output as String

  ## Examples

      Cmd.local "uname -v"  
      # => "Darwin Kernel Version 12.4.0: Wed May  1 17:57:12 PDT 2013; root:xnu-2050.24.15~1/RELEASE_X86_64\\n"
  """
  def local command do
    <<command::binary>> = command
    System.cmd command
  end

  @doc """
  Runs a shell command on your current node and return output on then senders conlose
  """
  def local sender, command do
    <<command::binary>> = command
    result = System.cmd command

    if sender do
      text = "#{Node.self} says: #{result}"
      Node.spawn(sender, IO, :puts, [text])
    end

    :ok
  end
end
