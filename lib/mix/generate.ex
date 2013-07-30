defmodule Mix.Tasks.Generate do
  use Mix.Task

  @shortdoc "Generates gh-pages"

  @moduledoc """
  Generates gh-pages from documentation
  """
  def run(_) do
    System.cmd "git co master"
    System.cmd "mix do deps.get, docs"
    System.cmd "cp -R docs/ /tmp/minion-docs/"
    System.cmd "git co gh-pages"
    System.cmd "cp -R /tmp/minion-docs/ docs/"
    System.cmd "git add docs"
    System.cmd "git commit -m 'Update docs'"
    System.cmd "git push"
    System.cmd "rm -rf /tmp/minion-docs"
    System.cmd "git co master"
  end
end
