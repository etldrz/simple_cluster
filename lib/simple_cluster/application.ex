defmodule SimpleCluster.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"n1@192.168.1.1", :"n2@192.168.1.2", :"n3@192.168.1.3"]]
        #config: [hosts: [:"n1@127.0.0.1", :"n2@127.0.0.1"]]
      ]
    ]
    children = [
      {Cluster.Supervisor, [topologies, [name: MyApp.ClusterSupervisor]]},
      SimpleCluster.Observer,
      SimpleCluster.Ping
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimpleCluster.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
