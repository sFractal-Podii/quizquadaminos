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
              AT&T Software Symposium Cybersecurity Workshop
              Quadblockquiz contest.
              Prizes are described at <a href={
                Routes.live_path(QuadblockquizWeb.Endpoint, QuadblockquizWeb.ContestPrizes)
              }>prizes</a>.
              This contests was organized by sFractal Consulting
              to increase awareness aand adoption of supply chain cybersecurity.
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
              Workshop attendees.
              Contestants must login to the game using the 'handle' option,
              and must choose a handle that is unique and somehow includes
              their attuid
              (e.g. sfractal_ds6284, ds6284, ds6284_isnotveryoriginal).
              The handle must be such that judges can figure our your attuid
              to award you the prize.
              Recall there may be a prize for originality, so be creative!
              You may have more than one handle, but can only win one prize.
              The email provided for your handle
              (you will be prompted for email first time a unique handle used)
              must be your att email to to be eligbile to win.
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
              but recognize there are hundreds of participants
              so there is the chance of overlap. And don't use 'anonymous'!
            </p>
            <p class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              The game does not check for overlap so pick something unique.
            </p>
            <div class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              <ul class="list-disc pl-4">
                <li>
                  You can play with more than one handle - but one person can only win one prize!
                </li>
                <li>The game should prompt you for your email when you first start to play.</li>
                <li>Once assigned, that handle will stay connected to that email address.</li>
                <li>
                  If it didn't prompt you for your email, you might have chosen an existing handle (hopefully yours).
                </li>
              </ul>
            </div>
            <p class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              Only valid att.com emails are elibigle to win prizes.
              The organizers must be able to
              to communicate with contest organizer about receiving their prize.
            </p>
            <p class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              The game must be played during eligle times.
              Make sure to finish your game cleanly so that you have seen the endgame screen with your score.
              To be on the safe side, take a pic of your end score screen
              in case there are issues with the game scoreboard.
            </p>
            <p class="border md:border-none rounded-lg md:rounded-lg-none border-gray-200 bg-slate-100 md:bg-white p-2 md:p-0">
              Contestants may submit more than one game,
              but only one prize per person.
              The contest scoreboard will automatically do,
              but note the leaderboard only shows games in progress.
              The final tally (including the finished games)
              doesn't show until the contest is over.
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
                  The "most points" gold medal prize will be awarded to the eligible
                  contest contestant with the highest points,
                  who will then be ineligible for the other Contest prizes.
                </li>
                <li>
                  The "most questions" gold medal prize will be awarded to the eligible
                  contest contestant who answered correctly the most trivia questions,
                  who will then be ineligible for the other Contest prizes.
                </li>
                <li>
                  The "most bricks" gold medal prize will be awarded to the eligible
                  contest contestant with the most number of bricks(quadblocks) in one game,
                  who will then be ineligible for the other Contest prizes.
                </li>
                <li>
                  Similarly for silver, bronze medals for points/questions/bricks.
                </li>
                <li>
                  The "????" prize will be awarded to the eligible
                  contest contestant based on surpise criteria announced
                  by the moderator at the contest.
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
