defmodule SharedSettingsUi.MixProject do
  use Mix.Project

  def project do
    [
      app: :shared_settings_ui,
      version: "0.2.0",
      elixir: "~> 1.10",
      description: description(),
      package: package(),
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
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:plug, "~> 1.10"},
      {:plug_cowboy, "~> 2.0", optional: true},
      {:jason, "~> 1.0", optional: true},
      {:redix, "~> 0.9", only: [:dev, :test]},
      {:shared_settings, "~> 0.2.0"}
    ]
  end

  defp description() do
    "UI for the Elixir shared-settings library"
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{repo: "https://github.com/kieraneglin/shared-settings-ui-ex"}
    ]
  end
end
