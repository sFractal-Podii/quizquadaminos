defmodule QuadblockquizWeb.ContestRules do
  use Phoenix.LiveView
  alias QuadblockquizWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~H"""
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
              Cybersecurity Automation Village
              Quadblockquiz contest.
              Prizes are described at <a href={
                Routes.live_path(QuadblockquizWeb.Endpoint, QuadblockquizWeb.ContestPrizes)
              }>prizes</a>.
              This contests was organized by sFractal Consulting
              to increase awareness aand adoption of supply chain cybersecurity
              as well as cybersecurity automation.
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
              registered attendees at the Cybersecurity Automation Village.
              Contestants must login to the game using the 'handle' option,
              and must choose a handle that is unique from other contestants.
              You should be asked for your email address on starting the first using that handle.
              If you are not asked for your email, then there is already an email for that handle.
              If it wasn't yours, then you are playing for someone else!
              You may have more than one handle, but can only win one prize.
              To to be eligbile to win,
              the email for your handle must match your email used to register for
              the Cybersecurity Automation Village.

              Your email address will kept private - only your handle will be shown.
            </p>
            <div class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              <ul class="list-disc pl-4">
                <li>
                  Contestants must be least 21 years of age or older to win prizes.
                </li>
                <li>
                  Contestants must logon to the game using the 'handle' option (NOT github, google, anonymous, etc).
                </li>
                <li>
                  The game does not check for overlapping handles so pick something unique.
                </li>
                <li>
                  Contestants may use any handle they want,but recognize there are hundreds of participants
                  so there is the chance of overlap. Eg don't use 'anonymous' and expect to be unique!
                </li>
                <li>
                  You can play with more than one handle - but one person can only win one prize!
                </li>
                <li>
                  The game should prompt you for your email on starting a game using that handle for first time.
                </li>
                <li>Once assigned, that handle will stay connected to that email address.</li>
                <li>
                  If it didn't prompt you for your email, you might have chosen an existing handle (hopefully yours).
                </li>
                <li>
                  Only valid emails are elibigle to win prizes.
                  The organizers must be able to
                  communicate with contest organizer about receiving their prize.
                </li>
                <li>
                  The game must be played during eligle times.
                  Make sure to finish your game cleanly so that you have seen the endgame screen with your score.
                  To be on the safe side, take a pic of your end score screen with your cell
                  in case there are issues with the game scoreboard.
                </li>
                <li>
                  Contestants may submit more than one game,
                  but only one prize per person.
                  The contest scoreboard will automatically do this,
                  but note the leaderboard only shows games in progress.
                  The final tally (including the finished games)
                  doesn't show until the contest is over.
                </li>
                <li>
                  You must enter the contest to win!!!!
                  Note there are two contests and you must pick one for each game played.
                </li>
                <li>
                  The "In Real Life" (IRL) Contest is for those physically present at the Village.
                  Although remote players can play the game, they are not eligible to win the IRL contest
                  and should sign up for the Hybrid contest instead.
                </li>
                <li>
                  The Hybrid Contest is for those remote from the conference, although nothing prevents
                  those physically present from entering Hybrid if they want to.
                </li>
                <li>
                  When you start to play each game, it will ask whether you want to be part of this contest.
                  You must enter the contest to be on the Contest Scoreboard.
                </li>
                <li>
                  Winners will be chosen based on their positions on the Contest Scoreboards.
                  Note the Contest Scoreboard is different than the Leaderboard (which is for "all-time").
                </li>
                <li>
                  A person can only win a single prize across the two Contests.
                </li>
                <li>
                  Note the winner maynot be the person at the top of the Contest Scoreboard
                  because people may be ineligible
                </li>
                <li>
                  To be eligible for IRL Contest prizes, the person must be physcially present
                  at lunch on Friday.
                  If not present, the person will be declared ineligible and the prize will go
                  to next eligible person.
                </li>
                <li>
                  The "most points" prize will be awarded to the eligible
                  contest contestant with the highest points,
                  who will then be **ineligible for the other Contest prizes**.
                </li>
                <li>
                  The "most questions" prize will be awarded to the eligible
                  contest contestant who answered correctly the most trivia questions,
                  who will then be ineligible for the other Contest prizes.
                </li>
                <li>
                  The "most bricks" prize will be awarded to the eligible
                  contest contestant with the most number of bricks(quadblocks) in one game,
                  who will then be ineligible for the other Contest prizes.
                </li>
                <li>
                  A person is only elegible to receive one prize,
                  (e.g first on points and first on bricks would only receive one prize for points, and then 'runner up' on bricks would win that prize).
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
              <a href={Routes.live_path(QuadblockquizWeb.Endpoint, QuadblockquizWeb.PrivacyLive)}>
                Privacy
              </a>
              policy and our <a href={
                Routes.live_path(QuadblockquizWeb.Endpoint, QuadblockquizWeb.TermsOfServiceLive)
              }> Terms Of Service </a>.
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
