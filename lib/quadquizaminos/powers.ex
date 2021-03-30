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
    :insurance,
    :sbom,
    :fixvuln,
    :fixlicense,
    :fixallvulns,
    :fixalllicenses,
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
