defmodule Cmd do
  def all <<command::binary>> do
    all Node.self, command
  end

  def all sender, <<command::binary>> do
    nodes = [Node.self | Node.list]
    execute sender, nodes, command
  end

  def other <<command::binary>> do
    other Node.self, command
  end

  def other sender, <<command::binary>> do
    execute sender, Node.list, command
  end

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
