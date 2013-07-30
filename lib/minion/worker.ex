defmodule Minion.Worker do

  @handshake "BANANA"

  def start_link do
    :timer.apply_interval(1000, __MODULE__, :announce, [])
    :timer.apply_interval(5000, __MODULE__, :receive_connections, [])

    {:ok, Kernel.self}
  end

  def announce do
    if length(Node.list) == 0 do
      {:ok, socket} = :gen_udp.open 6789
      :gen_udp.send(socket, {224,0,0,1}, 6790, "#{@handshake} #{Node.self}")
      :gen_udp.close socket
    end
  end

  def receive_connections do
    case :gen_udp.open(6790) do
      {:ok, socket} ->
        handle(socket)
      {:error, :eaddrinuse} ->
        "Somebody already listens for new nodes"
    end
  end

  def handle(socket) do
    :gen_udp.controlling_process(socket, spawn fn ->
      receive do
        {:udp,_,_,_,message} ->
          process_message(message)
          handle(socket)
      end
    end)
  end

  def process_message(message) do
    << @handshake, " ", name :: binary >> = "#{message}"

    Node.connect :"#{name}"

    # IO.puts "New node connected: #{inspect(name)}" # Debug
  end
end
