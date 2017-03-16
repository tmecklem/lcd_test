defmodule LcdTest.Mixfile do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"
  Mix.shell.info([:green, """
  Env
  MIX_TARGET:   #{@target}
  MIX_ENV:      #{Mix.env}
  """, :reset])
  def project do
    [app: :lcd_test,
     version: "0.0.1",
     elixir: "~> 1.4.0",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.3.0"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(@target),
     deps: deps()]
  end

  def application, do: application(@target)
  def application("host") do
    [extra_applications: [:logger]]
  end
  def application(_target) do
    [mod: {LcdTest.Application, []},
     extra_applications: [:logger, :elixir_lcd, :elixir_matrix_keypad, :elixir_ale]]
  end

  defp deps do
    [{:nerves, "~> 0.5.0", runtime: false}] ++
      deps(@target)
  end

  def deps("host"), do: []
  def deps(target) do
    [{:nerves_runtime, "~> 0.1.0"},
     {:"nerves_system_#{target}", "~> 0.11.0", runtime: false},
     {:elixir_lcd, github: "tmecklem/elixir_lcd"},
     {:elixir_matrix_keypad, github: "tmecklem/elixir_matrix_keypad"}]
  end

  def aliases("host"), do: []
  def aliases(_target) do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end
end

