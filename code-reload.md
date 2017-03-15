## Hot Code Reload Example

```bash
iex -S mix run --no-start
iex> {:ok, pid} = Main.start((), ())

# do code changes to the is_pizza_week function

iex> :ok = :sys.suspend(pid)
iex> c "lib/pizza.ex"
iex> :ok = :sys.change_code(pid, Pizza, "1", [:is_pizza_week])
iex> :ok = :sys.resume(pid)
```
