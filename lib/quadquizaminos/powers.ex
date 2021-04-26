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
    :slowvulns,
    :slowlicense,
    :legal,
    :cyberinsurance,
    :sbom,
    :fixvuln,
    :fixlicense,
    :rmallvulns,
    :rmalllicenses,
    :automation,
    :openchain,
    :stopattack,
    :winlawsuit,
    :superpower
  ]

  def all_powers() do
    @all_powers
    |> Enum.sort
  end

end
