defmodule SimpleCluster.Executer do
  use Agent

  def start_link(_arg) do
    Agent.start_link(fn -> :exec.start() end)
  end

  # Run the given command either synchronous or asynchronous.
  # Will return the result even if async is true.
  # The user can send new data to async process via send_to_process() function.
  # However, the user will not be able send new data to synchronous processes (since it will be blocking)
  # DOES NOT GIVE FINE CONTROL OVER THE COMMAND
  def run_command(cmd, async) do
    if async == true do
      # Since it is async, then the caller wouldn't care about the return value
      #{:ok, _ , osPID} = :exec.run_link(cmd, [{:stdout, &handle_async_result/3}, :stdin])
      {:ok, _ , osPID} = :exec.run_link(cmd, [{:stdout, :print}, :stdin])
      # So return the osPID so that the caller could use it for future use.
      #osPID
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

  # This helper function parse the output so that each element is on their own line.
  defp parse_output(output) do
    output |> String.split("\n") |> Enum.each(&IO.puts/1)
  end

  defp handle_async_result(_, _, data) do
    IO.puts(data)
  end
end
