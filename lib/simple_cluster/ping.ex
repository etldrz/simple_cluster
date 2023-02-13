defmodule SimpleCluster.Ping do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def ping do
    Node.list()
    |> Enum.map(&GenServer.call({__MODULE__, &1}, :ping))
    |> Logger.info()
  end

  def get_name do
    name = :inet.gethostname()
    Node.list()
    |> Enum.map(&GenServer.call({__MODULE__, &1}, name))
    |> Logger.info()
  end

  def send_name(nodeNum) do
    name = :inet.gethostname()
    list_of_nodes = Node.list()
    IO.puts(list_of_nodes[nodeNum])
    # if nodeNum < length(list_of_nodes) && nodeNum >= 0 do
    #   GenServer.call(list_of_nodes[nodeNum], name) |> Logger.info()
    # end
  end

  @impl GenServer
  def init(state), do: {:ok, state}

  @impl GenServer
  def handle_call(:ping, from, state) do
    Logger.info("--- Receiving ping from #{inspect(from)}")

    {:reply, {:ok, node(), :pong}, state}
  end

  def handle_call(name, from, state) do
    Logger.info("--- Receiving name from #{inspect(from)}, its name is #{inspect(name)}")
    {:reply, {:ok, node(), :pong}, state}
  end
end
