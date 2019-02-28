defmodule Absolutify.MixProject do
  use Mix.Project

  def project do
    [
      app: :absolutify,
      version: "0.1.2",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Absolutify.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:poison, "~> 4.0"},
      {:mock, "~> 0.3.0", only: :test},
      {:excoveralls, "~> 0.10", only: :test},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/mocks"]
  defp elixirc_paths(_), do: ["lib"]
end
