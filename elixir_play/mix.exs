defmodule FirstProj.Mixfile do
  use Mix.Project

  def project do
    [app: :first_proj,
     version: "0.0.1",
     elixir: "~> 1.3-dev",
     escript: escript,
     deps: deps]
  end

  def escript do
    [main_module: FirstProj, embed_elixir: true]
  end

  def application do
    [ applications: [:mix]] 
  end

  defp deps do
    [{:poison, "~> 2.1.0"}]
  end
end
