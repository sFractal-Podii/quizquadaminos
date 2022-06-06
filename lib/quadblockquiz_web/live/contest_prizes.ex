defmodule QuadblockquizWeb.ContestPrizes do
  use Phoenix.LiveView
  alias QuadblockquizWeb.Router.Helpers, as: Routes

  def render(assigns) do
    prices = [
      %{
        icon: "trophy",
        heading: "High Score",
        content:
          "One lucky person will win a tbd. The prize goes to ELIGIBLE person with the highest Score DURING THE CONTEST (see rules).",
        price: "tbd"
      },
      %{
        icon: "th",
        heading: "Most Bricks",
        content:
          " One lucky person will win a tbd. The prize goes to ELIGIBLE person with the the most bricks in a game DURING THE CONTEST (see rules). ",
        price: "tbd"
      },
      %{
        icon: "question",
        heading: "Most Questions",
        content:
          " One lucky person will win a tbd. The prize goes to ELIGIBLE person who answers the most trivia questions in the game DURING THE CONTEST (see rules). ",
        price: "tbd"
      },
      %{
        icon: "gift",
        heading: "???????",
        content: """
        One lucky person will win a
        tbd.
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
        """,
        price: "25"
      }
    ]

    ~L"""
    <h1 class="heading-1 mt-7 text-4xl tracking-widest">Contest Prizes</h1>
    <p class="pb-7">
    This is the prize page for the
    RSAC Supply Chain Sandbox QuadBlockQuiz contests.
    See
    <a href= <%= Routes.live_path(QuadblockquizWeb.Endpoint, QuadblockquizWeb.ContestRules) %> > Contest Rules </a>
    for more information on contest rules.
    </p>
    <p class="pb-7">
    Kicking off the contests will be the
    QuadBlockQuiz Celebrity Challenge
    live in the Sandbox.
    See supply chain cybersecurity celebrities like
    Beau Woods, Allan Freidman, and Sounil Yu
    compete for bragging rights.
    Or will they all be upstaged by last year's returning
    overall QuadBlockQuiz champion?
    Come to the Sandbox 3PM PDT on Tuesday June 7th to
    cheer on your favorite.
    </p>
    <p class="pb-7">
    As soon as the Celebrity Challenge ends,
    (i.e. 3:30 Pacific on Tues)
    the RSAC QuadBlockQuiz Open starts.
    There will be both a physical (i.e. in the Sandbox)
    and virtual contest.
    Contestants from either become eligible for the
    RSAC QuadBlockQuiz Finals in the Sandbox
    on Thursday June at 2PM Pacific.
    </p>
    <p class="pb-7">
    Prizes include signed copies of Souni Yu's new book.
    The grand prize is a private Cocktail Session via Zoom with
    Mixologist/Sommelier Chantal Tseng.
    This will include an in depth demo of three recipes catered to your favorite novel
    or other source of group inspiration. Chantal will provide advance recipes
    and a tool list for your unlimited number of guests
    who are then encouraged to make the drinks alongside and ask questions along the way.
    Class runs usually one to one and half hours long.
    Note the prize includes the recipes and the instruction but participants
    must purchase their own alcohol and ingredients.
    </p>


    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 mt-4 gap-4 place-items-center">
    <%= for price <- prices do %>
      <div class="bg-slate-100 p-4 pb-8 rounded-md text-center">
        <i class="text-blue-300 fas fa-<%= price.icon %> fa-4x mt-6"></i>
        <h2 class="heading-2 my-6"><%= price.heading %> </h2>
        <p class="text-sm pb-2"><%= price.content %></p>
        <span class="text-3xl font-bold"> $ <%=price.price %> </span>
      </div>
      <% end %>
    </div>
    """
  end
end
