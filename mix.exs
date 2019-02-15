defmodule Absolutify.MixProject do
  use Mix.Project

  def project do
    [
      app: :absolutify,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:poison, "~> 3.1"},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/mocks"]
  defp elixirc_paths(_), do: ["lib"]
end
