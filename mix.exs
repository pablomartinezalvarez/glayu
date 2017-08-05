defmodule Glayu.Mixfile do
  use Mix.Project

  def project do
    [app: :glayu,
     version: "0.1.0",
     elixir: "~> 1.4",
     escript: escript_config(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      mod: {GlayuApp, []},
      extra_applications: [:yamerl, :logger, :eex]
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
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:yamerl, "~> 0.4.0"},
      {:slugger, "~> 0.1.0"},
      {:earmark, "~> 1.1.0"}, # 1.2.0 has concurrency problems (check https://github.com/pragdave/earmark/issues/147)
      {:progress_bar, "> 0.0.0"},
      {:poolboy, "~> 1.5.1"},
      {:timex, "~> 3.0"},
      {:saul, "~> 0.1"},
      {:httpoison, "~> 0.11.1"},
      {:tzdata, "== 0.1.8", override: true}, # forces an old tzdata version (check https://github.com/lau/tzdata/issues/24)
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"}
    ]
  end

  defp escript_config do
    [ main_module: Glayu.CLI ]
  end
end
