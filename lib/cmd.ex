defmodule Cmd do
	def all <<command::binary>> do
		all Node.self, command
	end

	def all sender, <<command::binary>> do
		nodes = [Node.self | Node.list]
		execute sender, nodes, command
	end

	defp execute sender, list, <<command::binary>> do
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
