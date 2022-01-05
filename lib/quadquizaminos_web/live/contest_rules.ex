defmodule QuadquizaminosWeb.ContestRules do
  use Phoenix.LiveView
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <div class="">
      <div class="md:flex md:items-center md:justify-center">
        <div class="space-y-8">
          <h1 class="heading-1 md:text-center">Contest Rules</h1>
          <div class="flex flex-row gap-x-4 items-center justify-center md:hidden">
            <i class="fas fa-award fa-3x text-blue-200"></i>
            <i class="fas fa-gamepad fa-3x text-blue-200"></i>
            <i class="fas fa-list fa-2x text-blue-600 bg-blue-400 p-2"></i>
          </div>
          <div class="contest-rule md:max-w-5xl md:mx-auto md:bg-white md:border md:rounded-lg md:border-gray-200 space-y-4 md:p-6 lg:p-12 md:text-base  text-sm font-normal">
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
            <p class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              Contestants must be
              AT&T employees attending the Cybersecurity Workshop
              at the AT&T Software Symposium.
            </p>
            <p class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              Contestants must be least 21 years of age or older to win prizes.
            </p>
            <p class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              Contestants must logon to the game using the 'handle' option
              NOT github, google, anonymous, etc).
            </p>
            <p class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              Contestants may use any handle they want,
              but recognize there are over 500 participants
              so there is the chance of overlap.
            </p>
            <p class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              The game does not check for overlap so pick something unique.
            </p>
            <div class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              <p>
                Your ATTUID is unique but you probably want to combine it with something
                e.g. ds_sFractal_6284.
              </p>
              <ul class="list-disc pl-4">
                <li> You can play with more than one handle - but one person can only win one prize!</li>
                <li>The game should prompt you for your email when you first start to play.</li>
                <li>Once assigned, that handle will stay connected to that email address.</li>
                <li>If it didn't prompt you for your email, you might have chosen and existing handle.</li>
              </ul>
            </div>
            <p class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              Only valid AT&T emails are elibigle to win prizes.
              The organizers must be able to
              to communicate with contest organizer about reciving their prize.
              More importantly, the ATTUID is used to recieve MyRewards.
            </p>
            <p class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              The game must be played during eligle times.
              An eligible games must start and end during times announced during the workshop.
              The times will be on breaks, during the Q&A,
              and for 3 hours after the conclusion of the workshop.
              Games spanning timeslots will be ineligible
              (eg if start during first break and finish during second break).
              Make sure to finish your game cleanly so that you have seen the endgame screen with your score.
            </p>
            <p class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              Contestants may submit more than one game (the contest scoreboard will automatically do this for you),
              but only one prize per person.
            </p>
            <div class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              <p>
                You must enter the contest to win!!!!
                When you start to play each game, it will ask whether you want to be part of this contest.
                You must enter the contest to be on the Contest Scoreboard.
              </p>
              <ul class="list-disc pl-4">
                <li>
                  Winners will be chosen based on their positions on the Contest Scoreboards.
                  Note the Contest Scoreboard is different than the Leaderboard (which is for "all-time").
                </li>
                <li>
                  The "most points" prize will be awarded to the eligible
                  contest contestant with the highest points,
                  who will then be ineligible for the other Contest prizes.
                </li>
                <li>
                  The "most bricks" prize will be awarded to the eligible
                  contest contestant with the most number of bricks in one game,
                  who will then be ineligible for the other Contest prizes.
                </li>
                <li>
                  The "most questions" prize will be awarded to the eligible
                  contest contestant who answered correctly the most trivia questions,
                  who will then be ineligible for the other Contest prizes.
                </li>
                <li> 
                  The "????" prize will be awarded to the eligible
                  contest contestant based on surpise criteria announced
                  after the conclusion of the contest.
                </li>
                <li>
                  A person is only elegible to receive one prize per contest,
                  (e.g first on points and first on bricks would only receive one prize
                  for points, and then 'runner up' on bricks would win that prize).
                </li>
                <li> 
                  The organizers retain the right to adjust or shutdown the contest
                  at any time, and has the right to investigate possible cheating
                  or tampering.
                </li>
              </ul>
            </div>
            <p>
              See our
              <a href= <%= Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.PrivacyLive) %> > Privacy </a>
              policy and our <a href= <%= Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.TermsOfServiceLive) %> > Terms Of Service </a>.
              The TL;DR version is
              we only use your handle on the
              Leaderboard and Contest Scoreboard, and your email
              for the purpose of contacting you regarding prizes.
            </p>
          </div>  
        </div>
      </div>
    </div>
    """
  end
end
