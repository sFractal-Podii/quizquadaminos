defmodule QuadquizaminosWeb.ContestPrizes do
  use Phoenix.LiveView
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <h1>Contest Prizes</h1>
    <p>
    This is the prize page for the
    AT&T Software Symposium Security Workshop
    QuadBlockQuiz contest.
    See
    <a href= <%= Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.ContestRules) %> > Contest Rules </a>
    for more information on contest rules.
    </p>

    <h2>$25 MyRewards for High Score</h2>
    <p>
    One lucky person will win a
    $25 MyRewards Gift Card.
    The prize goes to ELIGIBLE person
    with the highest Score
    DURING THE CONTEST (see rules).
    </p>

    <h2>$25 MyRewards for Most Bricks</h2>
    <p>
    One lucky person will win a
    $25 MyRewards Gift Card.
    The prize goes to ELIGIBLE person
    with the the most bricks in a game
    DURING THE CONTEST (see rules).
    </p>

    <h2>$25 MyRewards for Most Questions</h2>
    <p>
    One lucky person will win a
    $25 MyRewards Gift Card.
    The prize goes to ELIGIBLE person
    who answers the most trivia questions in the game
    DURING THE CONTEST (see rules).
    </p>

    <h2>$25 MyRewards for ????????</h2>
    <p>
    One lucky person will win a
    $25 MyRewards Gift Card.
    The prize goes to ELIGIBLE person
    who meets a suprise criteria
    DURING THE CONTEST (see rules).
    In the past, the surpise criteria
    was the first questions in the lecture Q&A.
    Another time it was for finding a new bug
    in the game.
    Or it has been for the best question in the Q&A.
    Or it might be used when there is a tie.
    Or it could even be for the most creative handle.
    Or it might be some other criteria.
    </p>


    """
  end
end
