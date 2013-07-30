# Minion

## Installation

First, get dependencies and compile:  
`mix deps.get`  
`mix compile`

Then, start with  
`elixir --name minion --cookie minion --no-halt -pa ebin --app minion`

Or, Start interactive with  
`iex --name minion --cookie minion -S mix`

## Documentation

To get the documetation just run:  
`mix deps.get`  
`mix docs`

Then, have a look into your projects `/docs` folder.

## What to do with Minion

Execute shell commands on all Nodes:  
`Cmd.all "ls"`