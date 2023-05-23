defmodule SimpleCluster.Executer do
  use Agent

  def start_link(_arg) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  # Run the given command either synchronous or asynchronous.
  # Will return the result even if async is true.
  # The user can send new data to async process via send_to_process() function.
  # However, the user will not be able send new data to synchronous processes (since it will be blocking)
  # DOES NOT GIVE FINE CONTROL OVER THE COMMAND
  def run_command(cmd, async) do
    if async == true do
      {:ok, pid, osPID} = :exec.run_link(cmd, [{:stdout, &handle_async_result/3}, :stdin])
      # Put the new task and results in the map as a place holder
      Agent.update(__MODULE__, fn state ->
        Map.put_new(state, osPID, %{ready: false, results: []})
      end)
      Task.start(SimpleCluster.Executer, :start_monitoring, [pid])
      # So return the osPID so that the caller could use it for future use.
      osPID
    else
      {:ok, [stdout: result]} = :exec.run_link(cmd, [:sync, :stdout])
      # Just return the result
      Enum.each(result, &parse_output/1)
    end
  end

  #Run the given command with cmd_options and async options
  def run_command(cmd, cmd_options, async) do
    if async == true do
      # Since it is async, then the caller wouldn't care about the return value
      {:ok, _ , osPID} = :exec.run_link(cmd, cmd_options)
      # So return the osPID so that the caller could use it for future use.
      osPID
    else
      {:ok, [stdout: result]} = :exec.run_link(cmd, [:sync, :stdout] ++ cmd_options)
      # Just return the result
      result |> parse_output()
    end
  end

  # This function kills the given process
  def kill_process(pid) do
    :exec.stop(pid)
  end

  # This function returns all the children managed by current manager
  def get_all_children() do
    :exec.which_children()
  end

  # This function send data to stdin of the OS process identified by osPID.
  # Need to have stdin set in cmd_options
  def send_to_process(osPID, data) do
    :exec.send(osPID, data)
  end

  # This function allows the user to get the the result of the executed async commands.
  # Will return the whole result.
  def get_raw_result(osPID) do
    Agent.get(__MODULE__, fn state ->
      Map.get(state, osPID)
    end)
  end

  # This function returns only the content of the result even if the result is not ready yet.
  def get_partial_result(osPID) do
    Agent.get(__MODULE__, fn state ->
      cached = Map.get(state, osPID)
      if cached != nil do
        Map.get(cached, :results)
      else
        []
      end
    end)
  end

  # This function will return full result of the async task.
  # If the task is not finished, it will return nil instead of the partial result.
  def get_full_result(osPID) do
    result =  Agent.get(__MODULE__, fn state ->
      cached = Map.get(state, osPID)
      if cached != nil && Map.get(cached, :ready) do
        cached |> Map.get(:results)
      else
        []
      end
    end
    )
    # Delete the result if the result is ready.
    if result != nil do
      delete_result(osPID)
    end
    result
  end

  # This helper function parse the output so that each element is on their own line.
  defp parse_output(output) do
    output |> String.split("\n") |> Enum.each(&IO.puts/1)
  end

  defp handle_async_result(_, osPID, data) do
    Agent.update(__MODULE__, fn state ->
      Map.update!(state, osPID, fn value ->
        %{
          ready: false,
          results: Map.get(value, :results) ++ [data]
        }
      end)
    end)
    # IO.inspect(Agent.get(__MODULE__, fn state -> state end))
  end

  # This method deletes the result in the current Agent.
  defp delete_result(osPID) do
    Agent.update(__MODULE__, fn state ->
      Map.delete(state, osPID)
    end)
  end

  def start_monitoring(pid) do
    Process.monitor(pid)
    osPID = :exec.ospid(pid)
    receive do
      _ ->
        Agent.update(__MODULE__, fn state ->
          Map.update!(state, osPID, fn value ->
            %{
              ready: true,
              results: Map.get(value, :results)
            }
          end)
        end)
       # IO.inspect(Agent.get(__MODULE__, fn state -> state end))
    end
  end

end
