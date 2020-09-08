defmodule SharedSettings.UI do
  use Application

  @doc false
  def start(_type, _args) do
    check_cowboy()

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, FunWithFlags.UI.Router, [], [port: 8080])
    ]

    opts = [strategy: :one_for_one, name: FunWithFlags.UI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def run_standalone do
    Plug.Adapters.Cowboy.http SharedSettings.UI.Router, [], port: 4005
  end

  defp check_cowboy do
    with :ok <- Application.ensure_started(:ranch),
         :ok <- Application.ensure_started(:cowlib),
         :ok <- Application.ensure_started(:cowboy) do
      :ok
    else
      {:error, _} ->
        raise "You need to add :cowboy to your Mix dependencies to run FunWithFlags.UI standalone."
    end
  end

  defimpl Jason.Encoder, for: [SharedSettings.Setting] do
    def encode(setting, opts) do
      Jason.Encode.map(Map.from_struct(setting), opts)
    end
  end
end
