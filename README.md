# Minion

Start with

`elixir --name minion --cookie minion --no-halt -pa ebin --app minion`


Start interactive with

`iex --name minion --cookie minion -S mix`


Execute shell commands on all Nodes:

`Cmd.all "ls"`