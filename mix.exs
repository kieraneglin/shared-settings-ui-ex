defmodule SharedSettingsUi.MixProject do
  use Mix.Project

  def project do
    [
      app: :shared_settings_ui,
      version: "0.2.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.10"},
      {:plug_cowboy, "~> 2.0", optional: true},
      {:jason, "~> 1.0", optional: true},
      {:redix, "~> 0.9", only: [:dev, :test]},
      # TODO - change back to github link
      {:shared_settings, path: "../shared_settings"}
    ]
  end
end
