defmodule SharedSettings.UI do
  @spec run_standalone :: {:error, any} | {:ok, pid}
  def run_standalone do
    Plug.Adapters.Cowboy.http SharedSettings.UI.Router, [], port: 4005
  end

  defimpl Jason.Encoder, for: [SharedSettings.Setting] do
    def encode(setting, opts) do
      Jason.Encode.map(Map.from_struct(setting), opts)
    end
  end
end
