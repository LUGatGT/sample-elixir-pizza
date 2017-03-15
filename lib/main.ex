require Logger

defmodule Main do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Task, [Server, :accept, [8080]])
    ]
    opts = [
      strategy: :one_for_one,
      name: Server.Supervisor,
    ]

    Logger.info "Starting app..."
    Supervisor.start_link(children, opts)
  end
end
