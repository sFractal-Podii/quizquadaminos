defmodule Quadquizaminos.Presets do
  def five_by_nine() do
    %{{2, 15} => {2, 15, :pink},
      {3, 15} => {3, 15, :red},
      {4, 15} => {4, 15, :blue},
      {5, 15} => {5, 15, :green},
      {6, 15} => {6, 15, :orange},
      {7, 15} => {7, 15, :orange},
      {8, 15} => {7, 15, :orange},
      {9, 15} => {7, 15, :red},
      {10, 15} => {7, 15, :red},
      {2, 16} => {2, 16, :pink},
      {3, 16} => {3, 16, :red},
      {4, 16} => {4, 16, :blue},
      {5, 16} => {5, 16, :green},
      {6, 16} => {6, 16, :orange},
      {7, 16} => {7, 16, :purple},
      {8, 16} => {7, 16, :purple},
      {9, 16} => {7, 16, :red},
      {10, 16} => {7, 16, :red},
    }
  end

  def attack() do
    %{{1, 10} => {1, 10, :attack_yellow_gold},
      {2, 10} => {2, 10, :attack_yellow_gold},
      {3, 10} => {3, 10, :attack_yellow_gold},
      {4, 10} => {4, 10, :attack_yellow_gold},
      {5, 10} => {5, 10, :attack_yellow_gold},
      {6, 10} => {6, 10, :attack_yellow_gold},
      {7, 10} => {7, 10, :attack_yellow_gold},
      {8, 10} => {7, 10, :attack_yellow_gold},
      {9, 10} => {7, 10, :attack_yellow_gold}
    }
  end

  def lawsuit() do
    %{{5, 20} => {5, 20, :lawsuit_brown_gold},
      {5, 19} => {5, 19, :lawsuit_brown_gold},
      {5, 18} => {5, 18, :lawsuit_brown_gold},
      {5, 17} => {5, 17, :lawsuit_brown_gold},
      {5, 16} => {5, 16, :lawsuit_brown_gold},
      {5, 15} => {5, 15, :lawsuit_brown_gold},
      {5, 14} => {5, 14, :lawsuit_brown_gold},
      {5, 13} => {5, 13, :lawsuit_brown_gold},
      {5, 12} => {5, 12, :lawsuit_brown_gold},
      {5, 11} => {5, 11, :lawsuit_brown_gold}
    }
  end

end
