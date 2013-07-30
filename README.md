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

Look, there is [beautifully generated documentation](http://chaossteffen.github.io/Minion/docs/) for you! It describes all the features on the master branch.

To generate the documetation on your own, just run:  
`mix deps.get`  
`mix docs`

Then, have a look into your projects `/docs` folder.

## What to do with Minion

Execute shell commands on all Nodes:  
`Cmd.all "ls"`
