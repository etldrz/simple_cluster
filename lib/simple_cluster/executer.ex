defmodule SimpleCluster.Executer do
  use GenServer
  require Logger

  def start_link(_), do: GenServer.start_link(__MODULE__, %{})

  @impl GenServer
  def init(state) do
    # Supervisor.start_link([Task.Supervisor, name: SimpleCluster.TaskSupervisor], strategy: :one_for_one)
    {:ok, state}
  end


  @impl GenServer
  def handle_info({:EXIT, pid, reason}, state) do
    Logger.info("A child process died: #{reason}")
    {:noreply, state}
  end

  @impl GenServer
  def handle_info(term, state) do
    {:noreply, state}
  end


  def send_command(function_name, async) do
    # The background process will be killed after 10 minutes no matter what
    #default_timeout = 600_000
    # Run async and give a timeout
    #{:ok, pid} = Task.Supervisor.start_link()
    if async == true do
      #Task.Supervisor.start_child(pid, fn ->
      #  Rambo.run(function_name)
      #end, shutdown: default_timeout)
    else
      task = Task.async(fn ->
      Rambo.run(function_name)
    end)
      {:ok, result} = Task.await(task)
      output = String.split(result.out, "\n")
      #Enum.each(output, fn x -> IO.puts x end)
    end
  end

  def send_command(function_name, args_or_options, async) do
    # The background process will be killed after 10 minutes no matter what
    #default_timeout = 60000
    # Run async and give a timeout
    #{:ok, pid} = Task.Supervisor.start_link()
    if async == true do
      #Task.Supervisor.start_child(pid, fn ->
      #  Rambo.run(function_name, args_or_options)
      #end, shutdown: default_timeout)
    else
      task = Task.async(fn ->
        Rambo.run(function_name, args_or_options)
    end)
      {:ok, result} = Task.await(task)
      output = String.split(result.out, "\n")
      #Enum.each(output, fn x -> IO.puts x end)
    end
  end

  def send_command(function_name, args, opts, async) do
    # The background process will be killed after 10 minutes no matter what
    #default_timeout = 60000
    # Run async and give a timeout
    #{:ok, pid} = Task.Supervisor.start_link()
    if async == true do
      #Task.Supervisor.start_child(pid, fn ->
      #  Rambo.run(function_name, args, opts)
      #end, shutdown: default_timeout)
    else
      task = Task.async(fn ->
        Rambo.run(function_name, args, opts)
    end)
      {:ok, result} = Task.await(task)
      output = String.split(result.out, "\n")
      #Enum.each(output, fn x -> IO.puts x end)
    end
  end

end
