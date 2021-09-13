defmodule Quadquizaminos.Hints do
  def tldr(:intro) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>Fill all blocks in a row to clear the row.</p>
    <p>Right/left arrows move quads right/left.</p>
    <p>Up arrow rotates falling quad.</p>
    <p>Down arrow drops falling quad.</p>
    <p>Space bar pauses game and pops up quiz.</p>
    """
  end

  def tldr(:mobile) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p></p>
    <p>Playing without a keyboard is like
    ignoring cybersecurity of your supply chain.
    It quickly leads to bankruptcy!</p>
    <p></p>
    """
  end

  def tldr(:quiz) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>Space bar pops up quiz.</p>
    <p>Answer questions for points and powerups.</p>
    <p>Powerups let you delete blocks, add blocks, move blocks,
    prevent attacks, prevent lawsuits, etc</p>
    """
  end

  def tldr(:vuln) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>Don't let your supply chain get too long;
    if it reaches the top of the game board,
    you go bankrupt.</p>
    <p>Over time, your technical debt increases.
    At some point, vulnerabilities and/or licensing
    issues crop up in your supply chain</p>
    <p>Vulnerabilites are yellow/grey blocks.
    Licenseing issues are brown/grey blocks.
    Both prevent rows from being cleared</p>
    """
  end

  def tldr(:scoring) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>Each tick of the game clock gets points</p>
    <p>Clearing rows gets points. Clearing multiple Rows
    at once gets expontially increasing number of points</p>
    <p>Answering questions correctly gets points.
    Later questions are worth more than the initial questions</p>
    <p></p>
    """
  end

  def tldr(:scoring2) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>You lose points if you answer incorrectly
    (much fewer than you get for answering correctly
    so ok to guess).</p>
    <p>Attacks and lawsuits cause you to quickly lose points
    with each tick of the clock
    (hit spacebar to pause)</p>
    """
  end

  def tldr(:rm_vuln) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>Too many vulnerabilities results in a cyberattack.
    Too many licensing issues results in a lawsuit</p>
    <p>Certain powerups help with vulnerabilities,
    licensing issues, attacks, and lawsuits</p>
    <p></p>
    <p></p>
    """
  end

  def tldr(:clrblocks) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>ClearBlocks or the "eraser" powerup <i class="fas fa-eraser"></i>
    is a valuable powerup which clears the board of all
    blocks including vulnerabilities,
    licensing issues, attacks, and lawsuits</p>
    <p>The 9 Erasers are rewards for answering questions
    in the Phoenix category (ie you rise from the ashes)</p>
    """
  end

  def tldr(:speed) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>Certain powerups help with slowing up or speeding up</p>
    <p>Faster speeds mean more points - not just becasue ticks
    come more quickly, but also the number of points per click increases</p>
    <p>Faster speeds also increase the multiplier on clearing rows</p>
    <p></p>
    """
  end

  def tldr(:addblock) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p><i class="fas fa-plus-square"></i> is the addblock powerup</p>
    <p>It allows you to place a block in a free square</p>
    <p>It is a reward for certain quiz questions in Supply Chain Category</p>
    """
  end

  def tldr(:delblock) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>need delete block hints</p>
    <p></p>
    <p></p>
    """
  end

  def tldr(:mvblock) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>need moveblock hints</p>
    <p></p>
    <p></p>
    """
  end

  def tldr(:speedup) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>The speedup powerup (<i class="fas fa-fast-forward"></i>)
    speeds upthe pace of the game (e.g. from lethargic to sedate)</p>
    <p>It is most useful when hit by a lawsuit,
    since lawsuits slow down the game up to almost halted.</p>
    <p>Always keep a few in reserve.</p>
    <p>Speedup powerups can be found - which category(ies)?</p>
    """
  end

  def tldr(:slowdown) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>The slowdown powerup (<i class="fas fa-fast-backward"></i>)
    slows down the pace of the game (e.g. from fast to moderate)</p>
    <p>It is most useful when hit by a cyberattack,
    since cyberattacks speed the game up uncontrollably.</p>
    <p>Always keep a few in reserve.</p>
    <p>Slowdown powerups can be found - which category(ies)?</p>
    """
  end

  def tldr(:superpower) do
    """
    <p>Click "How to Play" for instructions.</p>
    <p>Make sure to answer questions in the vendor category.</p>
    <p>Vendors is the only place you can get 'superpower' powerup.</p>
    <p>Superpower (<i class="fab fa-superpowers"></i> ) can be traded
    in for other powers of your choice.</p>
    <p>Superpower is needed to get the powerups that stop cyberattacks or lawsuits</p>
    """
  end

  def tldr(_hint) do
    "Oops!"
  end

  def next_hint(previous_hint) do
    %{
      intro: :mobile,
      mobile: :quiz,
      quiz: :scoring,
      scoring: :scoring2,
      scoring2: :vuln,
      vuln: :rm_vuln,
      rm: :clrblocks,
      clrblocks: :addblock,
      addblock: :speed,
      speed: :delblock,
      delblock: :mvblock,
      mvblock: :speedup,
      speedup: :slowdown,
      slowdown: :superpower,
      superpower: :intro
    }
    |> Map.get(previous_hint, :intro)
  end
end
