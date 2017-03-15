defmodule Pizza do
    @doc "start our process"
    def start do
        Task.start_link(&loop/0)
    end

    def is_pizza_week time do
        weeks_since = (time - magic()) / (1000 * 60 * 60 * 24 * 7)
        (rem (trunc weeks_since), 2) === 1
    end

    defp loop do
        receive do
            {:get, caller} -> {:pizza, (send caller, ((System.system_time / 1000000) |> trunc |> is_pizza_week))}
        end
    end

    defp magic, do: 1476322937348
end

