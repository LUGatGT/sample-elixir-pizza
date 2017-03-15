require Logger

defmodule Main do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # this now becomes a supervision tree, a tree can
    # either contain apps, tasks, whatever to be supervised
    # or another supervisor
    children = [
      supervisor(Task.Supervisor, [
        [name: Server.TaskSupervisor]
      ]),
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
