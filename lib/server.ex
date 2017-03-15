require Logger

defmodule Server do
  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #
    {:ok, socket} = :gen_tcp.listen(port, [
      :binary,
      packet: :line,
      active: false,
      reuseaddr: true
    ])
    Logger.info "Accepting connections on port #{port}"

    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    # start a `Task.Supervisor`
    # allows the whole server not to crash if this does
    # allows many connections at once
    # such a common pattern there's a Task.Supervisor module
    {:ok, pid} = Task.Supervisor.start_child(
      Server.TaskSupervisor,  # process name
      fn -> serve(client) end # process function
    )
    # move the socket's controlling process to be `pid`
    :ok = :gen_tcp.controlling_process(client, pid)

    loop_acceptor(socket)
  end

  defp serve(socket) do
    _ = read_line socket
    time = DateTime.utc_now |> DateTime.to_unix
    write_line "{\"pizza\":#{Pizza.is_pizza_week time}}\n", socket
    serve socket
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end

