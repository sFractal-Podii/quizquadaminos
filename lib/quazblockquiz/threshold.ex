defmodule Quadblockquiz.Threshold do
  alias Quadblockquiz.Bottom

  ## used for either tech_vuln_debt or tech_lic_debt
  def reached_threshold(debt, threshold) do
    if debt + 1 < threshold do
      ## return new debt and add_vuln?=false
      {debt + 1, false}
    else
      ## set reached threshold and reset debt
      {0, true}
    end
  end

  def bad_happen(bottom, speed, score, under_attack?, being_sued?) do
    case {under_attack?, being_sued?} do
      {false, false} ->
        ## normal state, return new bottom and leave speed/score alone
        {bottom, speed, score}

      {true, false} ->
        ## under cyberattack means add attack blocks, reduce score, speed up game
        {Bottom.add_attack(bottom), 0, round(0.99 * score)}

      {false, true} ->
        ## being sued means add lawsuit blocks, reduce score, slow down game
        {Bottom.add_lawsuit(bottom), 6, round(0.99 * score)}

      {true, true} ->
        ## both lawsuit and cyberattack - add both blocks, reduce score more, speed up games
        bottom =
          bottom
          |> Bottom.add_lawsuit()
          |> Bottom.add_attack()

        speed = 0
        score = round(0.95 * score)
        {bottom, speed, score}
    end
  end
end
