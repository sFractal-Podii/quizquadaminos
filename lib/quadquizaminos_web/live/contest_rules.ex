defmodule QuadquizaminosWeb.ContestRules do
  use Phoenix.LiveView
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <h1>Contest Rules</h1>
    <p>
    These are the rules for the
    AT&T Software Symposium Security Workshop
    QuadBlockQuiz contest.
    Prizes are described at
    <a href= <%= Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.ContestPrizes) %> >prizes</a>.
    This contests was organized by sFractal Consulting
    to increase awarenessa and adoption of supply chain cybersecurity.
    </p>
    <p>
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
    Contestants must be
    AT&T employees attending the Cybersecurity Workshop
    at the AT&T Software Symposium.
    Contestants must be least 21 years of age or older to win prizes.
    </p>
    <p>
    Contestants must logon to the game using the 'handle' option
    (NOT github, google, anonymous, etc).
    Contestants may use any handle they want,
    but recognize there are over 500 participants so there is the change of overlap.
    The game does not check for overlap so pick something unique.
    Your ATTUID is unique but you probably want to combine it with something
    e.g. ds_sFractal_6284.
    You can play with more than one handle - but one person can only win one prize!
    The game should prompt you for your email when you first start to play.
    Once assigned, that handle will stay connected to that email address.
    If it didn't prompt you for your email, you might have chosen and existing handle.
    </p>
    <p>
    Only valid AT&T emails are elibigle to win prizes.
    The organizers must be able to
    to communicate with contest organizer about reciving their prize.
    More importantly, the ATTUID is used to recieve MyRewards.
    </p>
    <p>
    The game must be played during eligle times.
    An eligible games must start and end during times announced during the workshop.
    The times will be on breaks, during the Q&A,
    and for 3 hours after the conclusion of the workshop.
    Games spanning timeslots will be ineligible
    (eg if start during first break and finish during second break).
    Make sure to finish your game cleanly so that you have seen the endgame screen with your score.
    </p>
    <p>
    Contestants may submit more than one game (the contest scoreboard will automatically do this for you),
    but only one prize per person.
    </p>
    <p>
    You must enter the contest to win!!!!
    When you start to play each game, it will ask whether you want to be part of this contest.
    You must enter the contest to be on the Contest Scoreboard.
    </p>
    <p>
    Winners will be chosen based on their positions on the Contest Scoreboards.
    Note the Contest Scoreboard is different than the Leaderboard (which is for "all-time").
    </p>
    <p>
    The "most points" prize will be awarded to the eligible
    contest contestant with the highest points,
    who will then be ineligible for the other Contest prizes.
    </p>
    <p>
    The "most bricks" prize will be awarded to the eligible
    contest contestant with the most number of bricks in one game,
    who will then be ineligible for the other Contest prizes.
    </p>
    <p>
    The "most questions" prize will be awarded to the eligible
    contest contestant who answered correctly the most trivia questions,
    who will then be ineligible for the other Contest prizes.
    </p>
    <p>
    The "????" prize will be awarded to the eligible
    contest contestant based on surpise criteria announced
    after the conclusion of the contest.
    </p>
    <p>
    A person is only elegible to receive one prize per contest,
    (e.g first on points and first on bricks would only receive one prize
    for points, and then 'runner up' on bricks would win that prize).
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
    we only use your handle on the
    Leaderboard and Contest Scoreboard, and your email
    for the purpose of contacting you regarding prizes.
    </p>


    """
  end
end
