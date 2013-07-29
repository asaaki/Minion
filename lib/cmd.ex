defmodule Cmd do
  @moduledoc """
  This module provides allow you to execute remote shell commands and get back the output.

  ## Examples

      Cmd.all "uname -v"
      #=> #PID<0.101.0>
      #=> minion@MacBook-Air.local says: Darwin Kernel Version 12.4.0: Wed May  1 17:57:12 PDT 2013; root:xnu-2050.24.15~1/RELEASE_X86_64
      #=> minion@raspberry.local says: #1 PREEMPT Sun Jul 21 17:39:58 CDT 2013
  """

  @doc "Executes command on all nodes including yourself"
  def all <<command::binary>> do
    all Node.self, command
  end

  def all sender, <<command::binary>> do
    nodes = [Node.self | Node.list]
    execute sender, nodes, command
  end

  @doc "Executes command on all nodes except yourself"
  def other <<command::binary>> do
    other Node.self, command
  end

  def other sender, <<command::binary>> do
    execute sender, Node.list, command
  end

  @doc "Executes command on all nodes except the given nodes"
  def except nodes, <<command::binary>> do
    except Node.self, nodes, command
  end

  def except sender, nodes, <<command::binary>> do
    all_nodes = [Node.self | Node.list]

    Enum.each(all_nodes, fn(node) ->
      if !Enum.member?(nodes, node) do
        execute sender, [node], command
      end
    end)
  end

  @doc "Executes command only on the given nodes"
  def only nodes, <<command::binary>> do
    only Node.self, nodes, command
  end

  def only sender, nodes, <<command::binary>> do
    execute sender, nodes, command
  end

  def execute sender, list, <<command::binary>> do
    if length(list) > 0 do
      [head|rest] = list

      execute sender, rest, command

      Node.spawn(head, Cmd, :local, [sender, command])
    end
  end

  def local <<command::binary>> do
    System.cmd command
  end

  def local sender, <<command::binary>> do
    result = System.cmd command

    if sender do
      text = "#{Node.self} says: #{result}"
      Node.spawn(sender, IO, :puts, [text])
    end
  end
end
