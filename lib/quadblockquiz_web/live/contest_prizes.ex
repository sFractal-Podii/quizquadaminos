defmodule QuadblockquizWeb.ContestPrizes do
  use QuadblockquizWeb, :live_view
  alias QuadblockquizWeb.Router.Helpers, as: Routes

  def render(assigns) do
    prices = [
      %{
        icon: "trophy",
        heading: "IRL High Score",
        content: """
        A $100 Amazon Gift Card will be handed
        "in real life" (IRL)
        at lunch on Friday
        to the
        ELIGIBLE person with
        the highest score in the IRL contest (see rules).
        """,
        price: "$100"
      },
      %{
        icon: "question",
        heading: "IRL Most Questions",
        content: """
        A $50 Barnes & Noble Gift Card will be handed
        "in real life" (IRL)
        at lunch on Friday
        to the
        ELIGIBLE person who
        answers the most quiz questions
        in a game during the IRL contest (see rules).
        """,
        price: "$50"
      },
      %{
        icon: "th",
        heading: "IRL Most Bricks",
        content: """
        A $50 Home Depot Gift Card will be handed
        "in real life" (IRL)
        at lunch on Friday
        to the
        ELIGIBLE person
        with the most bricks
        in a game during the IRL contest (see rules).
        """,
        price: "$50"
      },
      %{
        icon: "trophy",
        heading: "Hybrid High Score",
        content: """
        A $50 Amazon Gift Card will be emailed
        after the Village to the
        ELIGIBLE person with
        the highest score in the Hybrid contest (see rules).
        """,
        price: "$50"
      },
      %{
        icon: "question",
        heading: "Hybrid Most Questions",
        content: """
        A $25 Barnes & Noble Gift Card will be emailed
        after the Village to the ELIGIBLE person who
        answers the most quiz questions
        in a game during the Hybrid contest (see rules).
        """,
        price: "$25"
      },
      %{
        icon: "th",
        heading: "Hybrid Most Bricks",
        content: """
        A $25 Home Depot Gift Card will be emailed
        after the Village
        to the
        ELIGIBLE person
        with the most bricks
        in a game during the Hybrid contest (see rules).
        """,
        price: "$25"
      }
    ]

    assigns = assign_new(assigns, :prices, fn -> prices end)

    ~H"""
    <h1 class="heading-1 mt-7 text-4xl tracking-widest">Contest Prizes</h1>
    <p class="pb-7">
      This is the prize page for the
      Cybersecurity Automation Village
      QuadBlockQuiz contests.
      See
      <a href={Routes.live_path(QuadblockquizWeb.Endpoint, QuadblockquizWeb.ContestRules)}>
        Contest Rules
      </a>
      for more information on contest rules.
    </p>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 mt-4 gap-4 place-items-center">
      <%= for price <- @prices do %>
        <div class="bg-slate-100 p-4 pb-8 rounded-md text-center">
          <i class={"text-blue-300 fas fa-#{price.icon} fa-4x mt-6"}></i>
          <h2 class="heading-2 my-6">{price.heading}</h2>
          <p class="text-sm pb-2">{price.content}</p>
          <span class="text-3xl font-bold">{price.price}</span>
        </div>
      <% end %>
    </div>
    """
  end
end
