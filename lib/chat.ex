defmodule Chat do
  @moduledoc """
  Documentation for Chat.
  """
  def receive_message(message) do
    IO.puts message
  end

  def receive_message_for_moebi(message, from) do
    IO.puts message
    send_message(from, "chicken?")
  end

  def send_message(:moebi@localhost, message) do
    spawn_task(__MODULE__, :receive_message_for_moebi, :moebi@localhost, [message, Node.self()])
  end

  def send_message(recipient, message) do
    spawn_task(__MODULE__, :receive_message, recipient, [message])
  end

  def spawn_task(module, fun, recipient, args) do
    Task.Supervisor.async(remote_supervisor(recipient), module, fun, args)
    |> Task.await
  end

  # defp do_spawn_task({module, fun, args}, :test) do
  #   apply(module, fun, args)
  # end

  # defp do_spawn_task({module, fun, recipient, args}, _) do
  #   Task.Supervisor.async(remote_supervisor(recipient), module, fun, args)
  #   |> Task.await
  # end

  defp remote_supervisor(recipient) do
    {Chat.TaskSupervisor, recipient}
    # {
    #   Application.get_env(:datasets_interface, :task_supervisor),
    #   Application.get_env(:datasets_interface, :node)
    # }
  end
end
