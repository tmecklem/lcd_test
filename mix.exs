defmodule LcdTest.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi"

  def project do
    [app: :lcd_test,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "0.1.2"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps ++ system(@target)]
  end

  def application do
    [applications: [:nerves, :logger, :elixir_lcd, :elixir_matrix_keypad, :elixir_ale],
     mod: {LcdTest, []}]
  end

  defp deps do
    [{:nerves, "~> 0.3.0"},
     {:elixir_lcd, path: "/Users/tmecklem/src/nerves/elixir_lcd"},
     {:elixir_matrix_keypad, path: "/Users/tmecklem/src/nerves/elixir_matrix_keypad"}]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end
end

