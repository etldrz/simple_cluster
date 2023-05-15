defmodule SimpleCluster.MixProject do
  use Mix.Project

  def project do
    [
      app: :simple_cluster,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      port: {:system, "PORT"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SimpleCluster.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libcluster, "~> 3.3"},
      {:rambo, "~> 0.3"},
      {:erlexec, "~> 2.0"}
    ]
  end
end
