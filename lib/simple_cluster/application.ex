defmodule SimpleCluster.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Node.start(:"n4@155.98.131.2")
    Node.set_cookie(:cluster1)
    # topologies = [
    #   gossip_example: [
    #     strategy: Elixir.Cluster.Strategy.Gossip,
    #     config: [
    #       port: 45892,
    #       if_addr: "0.0.0.0",
    #       multicast_addr: "255.255.255.255",
    #       broadcast_only: true
    #     ]
    #   ]
    # ]
    topologies = [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"n1@155.98.38.138", :"n2@155.98.38.152", :"n3@155.98.38.159", :"n4@155.98.131.2"]]
        #config: [hosts: [:"n1@192.168.1.1", :"n2@192.168.1.2", :"n3@192.168.1.3"]]
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
