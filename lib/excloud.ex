defmodule Excloud do
	def announce do
		{:ok, socket} = :gen_udp.open 6789
		:gen_udp.send(socket, {224,0,0,1}, 6790, "Node: #{Node.self}")
		:gen_udp.close socket
	end

	def receive_connections do
		case :gen_udp.open(6790) do
  		{:ok, _} ->
  			listen_to_socket
			{:error,:eaddrinuse} ->
				"Somebody already listens for new nodes"
		end
	end

	def listen_to_socket do
		receive do
			{:udp,_,_,_,message} ->
				process_message(message)
				listen_to_socket
		end
	end

	def process_message(message) do
		IO.puts "Message: #{inspect(message)}"
		<< "Node: ", node_name :: binary >> = "#{message}"

		IO.puts "node_name: #{inspect(node_name)}"

		Node.connect :"#{node_name}"
	end

end

Excloud.announce()
Excloud.receive_connections()