# Minion

## Installation

First, compile:  
`mix compile`

Then, start with  
`elixir --name minion --cookie minion --no-halt -pa ebin --app minion`

Or, Start interactive with  
`iex --name minion --cookie minion -S mix`

## What to do with Minion

Execute shell commands on all Nodes:  
`Cmd.all "ls"`