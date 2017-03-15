require Logger

defmodule Main do
  use Application

  def start(_type, _args) do
    Logger.info "Starting app..."
    Server.accept 8080
  end
end
