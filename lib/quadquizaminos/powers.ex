defmodule Quadquizaminos.Powers do
  @all_powers [
    :deleteblock,
    :addblock,
    :moveblock,
    :clearblocks,
    :nextblock,
    :speedup,
    :slowdown,
    :forensics,
    :legal,
    :cyberinsurance,
    :sbom,
    :fixvuln,
    :fixlicense,
    :rm_all_vulns,
    :rm_all_lic_issues,
    :automation,
    :openchain,
    :superpower
  ]

  def all_powers() do
    @all_powers
    |> Enum.sort
  end

end
