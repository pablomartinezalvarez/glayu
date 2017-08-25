defmodule Core.Mixfile do
  use Mix.Project

  def project do
    [
      app: :glayu_core,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.4",
      aliases: [test: "test --no-start"],
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      applications: [:logger, :yamerl, :eex],
      mod: {Glayu.Core, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:my_app, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:yamerl, "~> 0.4.0"},
      {:slugger, "~> 0.1.0"},
      {:saul, "~> 0.1"},
      {:httpoison, "~> 0.11.1"},
      {:earmark, "~> 1.1.0"}, # 1.2.0 has concurrency problems (check https://github.com/pragdave/earmark/issues/147)
      {:timex, "~> 3.0"},
      {:progress_bar, "> 0.0.0"}
    ]
  end
end
