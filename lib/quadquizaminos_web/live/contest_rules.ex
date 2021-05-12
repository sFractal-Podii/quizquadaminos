defmodule QuadquizaminosWeb.ContestRules do
    use Phoenix.LiveView
    import QuadquizaminosWeb.LiveHelpers
    alias QuadquizaminosWeb.Router.Helpers, as: Routes

    def render(assigns) do
        ~L"""
        <h1>Contest Rules</h1>
        <p>
        This contest is organized and sponsored by sFractal Consulting
        to celebrate and augment the Supply Chain Sandbox
        at RSAC.
        </p>
        <p>
        This contest is governed by these official rules.
        By participating in this contest,
        each entrant agrees to abide by these rules,
        including all eligiibility requirements,
        and understands the results of the contest,
        as determined by the Sponsor,
        are final in all respects.
        The contest is subject to all federal, state, and local laws
        and regulations and is void where prohibited by law.
        </p>
        <p>
        Contestants must be RSAC registered attendess who are at least 21 years of age or older to win prizes.
        </p>
        <p>
        Contestants must be participating in https://www.rsaconference.com/usa/agenda/session/supply-chain-activity-lounge
        during contest to be elible to win.
        </p>
        <p>
        Contestants must be logged in to QuadBlockQuiz with an identifiable id (i.e. not 'anonymous') to be able to win.
        </p>
        <p>
        To be eligible for prizes, a game must start after the contest start time (18-May 11:40 PDT)
        and must end cleanly before the contest end time (18-May 12:10 PDT).
        Time will be kept by game - don't start until AFTER the contest countdown reaches zero and the Contest Scoreboard activates.
        Make sure to finish your game cleanly so that you have seen the endgame screen with your score.
        </p>
        <p>
        Contestants may submit more than one game (the contest scoreboard will automatically do this for you), but are only eligible for one prize.
        </p>
        <p>
        Winners will be chosen based on their positions on the Contest Scoreboards.
        Note the Contest Scoreboard is different than the Leaderboard.
        The Leaderboard shows scores based on the the entire time of RSAC and does not result in prizes.
        The Contest Scoreboard only shows games that started after the  contest start time and finished prior to the contest endtime.
        </p>
        <p>
        Contestants must participate in the awards ceremony during https://www.rsaconference.com/usa/agenda/session/sipping-bill-of-materials
        to be able to select their prize and win. Those unavailable to participate in the awards ceremony must make previous arrangements with conference organizer during contest.
        </p>
        <p>
        Winners will select <a href= <%= Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.ContestPrizes) %> >prizes</a>
        based on the order the winners appear on the Contest Scoreboards which include respective best scores for points, bricks, and questions.
        </p>
        <p>
        A person is only elegible to receive one prize, even if they appear on multiple contest Scoreboards
        (e.g first on points and third on bricks) or with multiple ID's.
        </p>
        <p>
        There are three contest scoreboards (points, bricks, questions).
        The first person to pick a prize will be the eligible contestant with the highest point score.
        The second person to pick a prize will be the next eligible contestant with the most dropped bricks.
        The third person to pick a prize will be the next eligible contestant with the most answered questions.
        The fourth person to pick a prize will be the next eligible contestant with the next highest point score.
        Selection will continue until we run out of prizes or people.
        </p>
        <p>
        The organizers retain the right to adjust or shutdown the contest
        at any time and retain the right to investigate possible cheating
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
