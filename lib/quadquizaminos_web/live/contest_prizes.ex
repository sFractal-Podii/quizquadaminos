defmodule QuadquizaminosWeb.ContestPrizes do
    use Phoenix.LiveView
    import QuadquizaminosWeb.LiveHelpers
    alias QuadquizaminosWeb.Router.Helpers, as: Routes

    def render(assigns) do
        ~L"""
        <h1>Contest Prizes</h1>
        <p>
        These prizes are in no particular order. See
        <a href= <%= Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.ContestRules) %> > Contest Rules </a>
        for order winners will be selected. Winners will then pick from available prizes.
        </p>
        <h2>Custom Cocktail Instruction from a Superlative Mixologist</h2>
        <p>
        One lucky person will win a private Cocktail Session via Zoom with
        Mixologist/Sommelier Chantal Tseng.
        This will include an in depth demo of three recipes catered to your favorite novel
        or other source of group inspiration. Chantal will provide advance recipes
        and a tool list for your unlimited number of guests
        who are then encouraged to make the drinks alongside and ask questions along the way.
        Class runs usually one to one and half hours long.
        Note the prize includes the recipes and the instruction but participants
        must purchase their own alcohol and ingredients.
        </p>
        <a href="https://cocktailsforendtimes.com/" class="phx-logo">
          <img src="/images/Cocktail3.png" alt="Cocktails For Endtimes Logo">
        </a>
        <h2>Absinthe Tutorial from an Award-Winning Mixologist</h2>
        <p>
        One lucky person will win a private Absinthe tutorial with
        Mixologist/Sommelier Chantal Tseng.
        You and your unlimited number of guests will schedule a time on Zoom
        where Chantal will teach a condensed class covering
        the history and myths of Absinthe, proper service and its usage in cocktails.
        Guests are encouraged to pick up a bottle beforehand
        and will be given a list of recommendations.
        Class will run 45 minutes to an hour long.
        Note the prize includes the recipes and the instruction but participants
        must purchase their own alcohol and ingredients.
        </p>
        <h2>Custom Cocktail Recipe</h2>
        <p>
        Five lucky people will win their very own custom cocktail recipe
        designed by Mixologist/Sommelier
        Chantal Tseng based on your home bar inventory and literary tastes.
        Simply head over to www.cocktailsforendtimes.com to fill out the form
        and she'll email you your recipe complete with user friendly instruction
        and explanation when it is finished.
        Recipes are as simple or as intricate as your home bar will allow.
        The more details, the better!
        </p>
        <h2>Briar Cutter Writing</h2>
        <p>
        One lucky person will will 5 hours of consultation
        from Briar Cutter marketing/writing consultants.
        <a href="https://briarcutter.com/" class="phx-logo">
          <img src="/images/Briar Cutter Final PNG@2x.png">
        </a>
        </p>
        <h2>Podii Software Development</h2>
        <p>
        One lucky person will will 5 hours of consultation
        from Podii, as software consulting company.
        <a href="https://podiihq.com/" class="phx-logo">
          <img src="/images/podiilogo.png">
        </a>
        </p>
        <h2>sFractal Cybersecurity</h2>
        <p>
        One lucky person will will 5 hours of consultation
        from sFractal Consulting, a botique cybersecurity and software development company.
        <a href="https://sfractal.com/" class="phx-logo">
          <img src="/images/sFractalConsulting.png">
        </a>
        </p>
        """
      end
end
