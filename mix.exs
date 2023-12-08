defmodule Gazettex.MixProject do
  use Mix.Project

  def project do
    [
      app: :gazettex,
      version: "0.1.0",
      elixir: "~> 1.14",
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
      {:grpc, "~> 0.7"},
      {:protobuf, "~> 0.11"},
      {:google_protos, "~> 0.1"}
    ]
  end
end
