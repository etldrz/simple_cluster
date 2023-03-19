# SimpleCluster

To Run:
iex --name n@192.168.1.x -S mix



## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `simple_cluster` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:simple_cluster, "~> 0.1.0"}
  ]
end
```

If not published in Hex and wish to use local library, use the following:

```elixir
Mix.install(
  [
    {:simple_cluster, path:"/path/to/mix.exs"}
  ]
)
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/simple_cluster>.

## Livebook Requirement

Need to lunch livebook like so that it can use fully qualified names.
```shell
livebook server --name
```
