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
    [extra_applications: [:yamerl, :logger, :eex],
    mod: {GlayuApp, []}]
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
      {:earmark, "~> 1.2.0"},
      {:progress_bar, "> 0.0.0"},
      {:credo, "~> 0.7", only: [:dev, :test]}
    ]
  end

  defp escript_config do
    [ main_module: Glayu.CLI ]
  end
end
