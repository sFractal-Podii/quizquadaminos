defmodule Quadquizaminos.Powers do
  @all_powers [
    :deleteblock,
    :addblock,
    :moveblock,
    :clearblocks,
    :speedup,
    :slowdown,
    :fixvuln,
    :fixlicense,
    :rm_all_vulns,
    :rm_all_lic_issues,
    :superpower
  ]

  def all_powers() do
    @all_powers
    |> Enum.sort()
  end
end
