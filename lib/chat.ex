defmodule Chat do
  @moduledoc """
  Documentation for Chat.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Chat.hello()
      :world

  """
  def hello do
    :world
  end

  def send_message(recipient, message) do
    __MODULE__.spawn_task(__MODULE__, :receive_message, recipient, [message])
  end

  def receive_message(message) do
    IO.puts message
  end

  def spawn_task(module, fun, recipient, args, env \\ Mix.env) do
    do_spawn_task({module, fun, recipient, args}, env)
  end

  # defp do_spawn_task({module, fun, args}, :test) do
  #   apply(module, fun, args)
  # end

  defp do_spawn_task({module, fun, recipient, args}, _) do
    Task.Supervisor.async(remote_supervisor(recipient), module, fun, args)
    |> Task.await
  end

  defp remote_supervisor(recipient) do
    {Chat.TaskSupervisor, recipient}
    # {
    #   Application.get_env(:datasets_interface, :task_supervisor),
    #   Application.get_env(:datasets_interface, :node)
    # }
  end
end
