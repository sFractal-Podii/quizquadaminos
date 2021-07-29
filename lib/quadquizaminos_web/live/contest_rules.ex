defmodule QuadquizaminosWeb.ContestRules do
  use Phoenix.LiveView
  import QuadquizaminosWeb.LiveHelpers
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <h1>Contest Rules</h1>
    <p>
    There will two contests: "1-hour" and "24-hour".
    These contests are organized and sponsored by sFractal Consulting
    to increase awarenessa and adoption of supply chain cybersecurity.
    </p>
    <p>
    Both of these contests are governed by these official rules.
    By participating in a contest,
    each entrant agrees to abide by these rules,
    including all eligibility requirements,
    and understands the results of the contest,
    as determined by the Sponsor,
    are final in all respects.
    The contest is subject to all federal, state, and local laws
    and regulations and is void where prohibited by law.
    </p>
    <p>
    Contestants must be BSidesLV attendess who are at least 21 years of age or older to win prizes.
    </p>
    <p>
    For the "1-hour" contest,
    contestants must be participating live in the
    <a href="https://www.bsideslv.org/talks#1045530">
    "QuadBlockQuiz - Supply Chain Sandbox Edition"
    </a>
    session to be elible to win.
    Prizes for the "1-hour" contest will be announced during the Q&A session after the talk.
    </p>
    <p>
    Contestants must be logged in to QuadBlockQuiz with an identifiable id (i.e. not 'anonymous') to be able to win.
    </p>
    <p>
    To be eligible for prizes, a game must start after the contest start time
    and must end cleanly before the contest end time.
    Both contests will start
    1-Aug 16:00 PDT when the
    <a href="https://www.bsideslv.org/talks#1045530">
    "QuadBlockQuiz - Supply Chain Sandbox Edition"
    </a>
    talk starts.
    The "1-hour" contest will be less than one hour and will be stopped
    at a random time announced
    by the speaker during the Q&A session for
    <a href="https://www.bsideslv.org/talks#1045530">
    "QuadBlockQuiz - Supply Chain Sandbox Edition"
    </a>
    The "24-hour" contest will run until 2-Aug 16:00 PDT.
    </p>
    <p>Time will be kept by game - don't start until AFTER the talk has started and the Contest Scoreboard activates.
    Make sure to finish your game cleanly so that you have seen the endgame screen with your score.
    </p>
    <p>
    Contestants may submit more than one game (the contest scoreboard will automatically do this for you), but are only eligible for one prize.
    </p>
    <p>
    Winners will be chosen based on their positions on the Contest Scoreboards.
    Note the Contest Scoreboard is different than the Leaderboard (which is for "all-time").
    The Contest Scoreboard only shows games that started after the  contest start time and finished prior to the contest endtime.
    </p>
    <p>
    For the "1-hour" Contest, contestants must participate in the awards ceremony during Q&A for
    <a href="https://www.bsideslv.org/talks#1045530">
    "QuadBlockQuiz - Supply Chain Sandbox Edition"
    </a>
    to win. Winners for the "24-hour" Contest will be contacted based on contact information
    associated with their logon credentials.
    They want to contact the contest organizer directly to make sure.
    </p>
    <p>
    Prizes are described at
    <a href= <%= Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.ContestPrizes) %> >prizes</a>.
    </p>
    <p>
    The "Custom Cocktail Instruction" prize will be awarded to the eligible
    "1-hour" contest contestant with the highest points,
    who will then be ineligible for more "1-hour" Contest prizes,
    and also ineligible for the "Absinthe Tutorial" prize.
    </p>
    <p>
    The "Risk Book & Custom Cocktail Recipe" prize will be awarded to the eligible
    "1-hour" contest contestant with the most answered questions,
    who will then be ineligible either of the next prize.
    </p>
    <p>
    The "Custom Cocktail Recipe" prize will be awarded to the eligible
    "1-hour" contest contestant with the most bricks.
    </p>

    <p>
    The "Absinthe Tutorial" prize will be awarded to the eligible
    "24-hour" contest contestant with the highest points,
    who will then be ineligible for more "24-hour" Contest prizes.
    </p>
    <p>
    The "Risk Book & Custom Cocktail Recipe" prize will be awarded to the eligible
    "24-hour" contest contestant with the most answered questions,
    who will then be ineligible for more "24-hour" Contest prizes.
    </p>
    <p>
    The "Custom Cocktail Recipe" prize will be awarded to the eligible
    "24-hour" contest contestant with the most bricks.
    </p>    
    <p>
    A person is only elegible to receive one prize per contest,
    (e.g first on points and first on bricks would only receive one prize)
    or with multiple ID's.
    </p>
    <p>
    The first person to pick a prize will be the eligible contestant with the highest point score.
    The second person to pick a prize will be the next eligible contestant with the most dropped bricks.
    The third person to pick a prize will be the next eligible contestant with the most answered questions.
    The fourth person to pick a prize will be the next eligible contestant with the next highest point score.
    Selection will continue until we run out of prizes or people.
    </p>
    <p>
    Previous winners of the "Custom Cocktail Instruction" prize at RSAC (ie Oddie)
    are not elibible to win that prize again, but are eligible for all other prizes.
    Previous winners of the "Absinthe Tutorial" prize at RSAC (ie Rick)
    are not elibible to win that prize again, but are eligible for all other prizes.
    All other RSAC prize winners are eligible for all prizes at BSidesLV.
    The winner of the BSidesLV "Custom Cocktail Instruction" prize
    in the "1-hour" contest
    is not eligible for the "Absinthe Tutorial" prize in the "24-hour" contest.
    </p>
    <p>
    The organizers retain the right to adjust or shutdown the contest
    at any time, and has the right to investigate possible cheating
    or tampering.
    </p>
    <p>
    See our
    <a href= <%= Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.PrivacyLive) %> > Privacy </a>
    policy and our <a href= <%= Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.TermsOfServiceLive) %> > Terms Of Service </a>.
    The TL;DR version is
    we only use your ID to put your name (as provided publicly by your ID) on the
    Leaderboard and Contest Scoreboard, and your email (as provided by your ID)
    for the purpose of contacting you regarding prizes.
    </p>
    """
  end
end
