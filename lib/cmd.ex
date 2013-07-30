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
    all(command, function(Cmd.print_output/2))
  end

  @doc """
  Runs a shell command on all nodes including yourself and takes a function that gets back the output

  ## Examples

      Cmd.all "uname -v", fn(node, result) ->
        text = "\#{node} says: \#{result}"
        IO.puts text
      end
      #=> :ok
      #=> minion2@MacBook-Air.local says: Darwin Kernel Version 12.4.0: Wed May  1 17:57:12 PDT 2013; root:xnu-2050.24.15~1/RELEASE_X86_64
      #=> minion@MacBook-Air.local says: Darwin Kernel Version 12.4.0: Wed May  1 17:57:12 PDT 2013; root:xnu-2050.24.15~1/RELEASE_X86_64
  """
  def all command, complete do
    Minion.execute(Minion.all, Cmd, :local, [command, complete])
  end

  @doc "Executes command on all nodes except yourself"
  def other command do
    other command, fn(node, result) ->
      text = "#{node} says: #{result}"
      IO.puts text
    end
  end

  @doc "Executes command on all nodes except yourself and takes a function that gets back the output"
  def other command, complete do
    Minion.execute Minion.other, Cmd, :local, [command, complete]
  end

  @doc "Executes command on all nodes except the given nodes"
  def except nodes, command do
    except nodes, command, fn(node, result) ->
      text = "#{node} says: #{result}"
      IO.puts text
    end
  end

  @doc "Executes command on all nodes except the given nodes and takes a function that gets back the output"
  def except nodes, command, complete do
    Enum.each(Minion.all, fn(node) ->
      unless Enum.member?(nodes, node) do
        Minion.execute [node], Cmd, :local, [command, complete]
      end
    end)
  end

  @doc "Executes command only on the given nodes"
  def only nodes, command do
    only nodes, command, fn(node, result) ->
      text = "#{node} says: #{result}"
      IO.puts text
    end
  end

  @doc "Executes command only on the given nodes and takes a function that gets back the output"
  def only nodes, command, complete do
    Minion.execute nodes, Cmd, :local, [command, complete]
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
  Runs a shell command on your current node and takes a function that gets back the output
  """
  def local command, complete do
    <<command::binary>> = command
    result = System.cmd command

    if complete do
      complete.(Minion.me, result)
    end

    :ok
  end

  def print_output node, result do
    IO.puts "#{node} says: #{result}"
  end
end
