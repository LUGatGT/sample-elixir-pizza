defmodule Pizza do
    def is_pizza_week time do
        weeks_since = (time - magic()) / (60 * 60 * 24 * 7)
        (rem (trunc weeks_since), 2) === 1
    end

    defp magic, do: 1476322937
end

