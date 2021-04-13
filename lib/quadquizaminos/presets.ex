defmodule Quadquizaminos.Presets do
  def five_by_nine() do
    %{{2, 15} => {2, 15, :pink},
      {3, 15} => {3, 15, :red},
      {4, 15} => {4, 15, :blue},
      {5, 15} => {5, 15, :green},
      {6, 15} => {6, 15, :orange},
      {7, 15} => {7, 15, :purple},
      {8, 15} => {8, 15, :orange},
      {9, 15} => {9, 15, :red},
      {10, 15} => {10, 15, :red},
      {2, 16} => {2, 16, :pink},
      {3, 16} => {3, 16, :red},
      {4, 16} => {4, 16, :blue},
      {5, 16} => {5, 16, :green},
      {6, 16} => {6, 16, :orange},
      {7, 16} => {7, 16, :purple},
      {8, 16} => {8, 16, :purple},
      {9, 16} => {9, 16, :red},
      {10, 16} => {10, 16, :red},
      {2, 17} => {2, 17, :pink},
      {3, 17} => {3, 17, :purple},
      {4, 17} => {4, 17, :blue},
      {5, 17} => {5, 17, :green},
      {6, 17} => {6, 17, :purple},
      {7, 17} => {7, 17, :purple},
      {8, 17} => {8, 17, :purple},
      {9, 17} => {9, 17, :red},
      {10, 17} => {10, 17, :red},
      {2, 18} => {2, 18, :purple},
      {3, 18} => {3, 18, :red},
      {4, 18} => {4, 18, :blue},
      {5, 18} => {5, 18, :green},
      {6, 18} => {6, 18, :orange},
      {7, 18} => {7, 18, :purple},
      {8, 18} => {8, 18, :purple},
      {9, 18} => {9, 18, :red},
      {10, 18} => {10, 18, :red},
      {2, 19} => {2, 19, :pink},
      {3, 19} => {3, 19, :pink},
      {4, 19} => {4, 19, :pink},
      {5, 19} => {5, 19, :pink},
      {6, 19} => {6, 19, :orange},
      {7, 19} => {7, 19, :purple},
      {8, 19} => {8, 19, :purple},
      {9, 19} => {9, 19, :red},
      {10, 19} => {10, 19, :red},
      {2, 20} => {2, 20, :pink},
      {3, 20} => {3, 20, :red},
      {4, 20} => {4, 20, :pink},
      {5, 20} => {5, 20, :green},
      {6, 20} => {6, 20, :pink},
      {7, 20} => {7, 20, :green},
      {8, 20} => {8, 20, :purple},
      {9, 20} => {9, 20, :red},
      {10, 20} => {10, 20, :green}
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
      {8, 10} => {8, 10, :attack_yellow_gold},
      {9, 10} => {9, 10, :attack_yellow_gold}
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

  def preset_vuln() do
    %{
      {2, 20} => {2, 20, :pink},
      {3, 20} => {3, 20, :red},
      {4, 20} => {4, 20, :vuln_grey_yellow},
      {5, 20} => {5, 20, :green},
      {6, 20} => {6, 20, :vuln_grey_yellow},
      {7, 20} => {7, 20, :green},
      {8, 20} => {8, 20, :vuln_grey_yellow},
      {9, 20} => {9, 20, :red},
      {10, 20} => {10, 20, :vuln_grey_yellow}
    }
  end

  def preset_lic() do
    %{
      {2, 20} => {2, 20, :pink},
      {3, 20} => {3, 20, :red},
      {4, 20} => {4, 20, :license_grey_brown},
      {5, 20} => {5, 20, :green},
      {6, 20} => {6, 20, :license_grey_brown},
      {7, 20} => {7, 20, :green},
      {8, 20} => {8, 20, :license_grey_brown},
      {9, 20} => {9, 20, :red},
      {10, 20} => {10, 20, :license_grey_brown}
    }
  end


end
