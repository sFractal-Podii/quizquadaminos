defmodule QuadquizaminosWeb.Instructions do


    def game_instruction() do
    """
    <h2>Why Play?</h2>
    <p>You are at RSAC because you either "sell security" or you "buy security".
      In either case, this SupplyChainSandbox is where you need to be.
      As recent events have shown, you are only as protected as the weakest link in your supply chain.
      The security vendors need to avoid "the cobbler's children going barefoot"
      (a favorite saying of the game author throughout his career
      that he unfortunately has found to be true too often in the security community)
      and worry about their supply chain.
      Similarly, the security user community needs to know supply chain security
      of all their vendors - as well as recognize they are the supply chain for their customers.
      </p>
      <p>
      Protecting your organization’s information in a digitally-connected world
      means understanding not only your organization’s immediate supply chain,
      but also the security of the extended ecosystem and all entities involved.
      The SupplyChainSandbox is educating the public about supply chain risk management
      through an interactive fun and educational experience.
      You don't need to be a supply chain expert - this game assumes you are a novice
      and it teaches you what you need to know.
      </p>
      <p>
      QuadBlocksQuiz/Supply-Chain-Sandbox Edition is the love child of Tetris and Trivia.
      You gain points by clearing rows as in a typical Tetris game.
      You can answer quiz questions about supply chain both to gain points and to gain powerups.
      Powerups help with classic Tetris strategy but also are needed
      to combat vulnerabilities (blocks that gum up clearing rows), licensing issues
      (another block that gum up clearing rows), cyber attacks
      (that take over entire sections of the gameboard and speed the game up uncontrollably),
      and licensing lawsuits (that gum up entire sections of the game board
      and slow the game to a snail's pace).
      Some powerups help prevent vulnerabilities, licensing errors, cyber attacks, or lawsuits.
      Others slow down the game (if it's going too fast) or speed it up (if it's going too slow).
      Others help mitigate vulnerabilities, licensing errors, cyber attacks, or lawsuits.
      </p>
      <p>
      Clear blocks or learn supply chain security? Just like real life,
      the answer is “it depends”.
      Just like in real life, you can ignore cybersecurity
      and probably be OK (at least for a while)
      if you are fast and lucky. But just like in real life,
      your technical debt in ignoring cybersecurity will eventually catch up to you.
      Play the game and find out!
      </p>
    <h2>How to play</h2>
    <h3>Movement</h3>
        <ol>
          <li>Up arrow key rotates the blocks</li>
          <li>Left arrow key moves the blocks to the left</li>
          <li>Right arrow key moves the blocks to the right</li>
          <li>Down arrow key moves the blocks down</li>
          <li>space bar pauses game and brings up quiz</li>
        </ol>
    <h3>Speed</h3>
            <ol>
              <li>blah blah</li>
            </ol>
    <h3>Scoring</h3>
        <ol>
          <li>blah blah</li>
        </ol>
    <h3>Quiz</h3>
      <ol>
        <li>blah blah</li>
      </ol>
    <h3>Powerups</h3>
      <ol>
        <li>+ add a block</li>
        <li>- remove a block</li>
        <li>blah move a block</li>
      </ol>
- Arrows for move (https://fontawesome.com/icons/arrows-alt?style=solid)
- eraser for clearblocks (https://fontawesome.com/icons/eraser?style=solid)
- fast-forward for speedup (https://fontawesome.com/icons/fast-forward?style=solid)
- fastbackwards for slow down (https://fontawesome.com/icons/fast-backward?style=solid)
- Wrench for fixing a vulnerability (https://fontawesome.com/icons/wrench?style=solid)
- screwdriver for fixing a license error (https://fontawesome.com/icons/screwdriver?style=solid)
- 3/4 battery for reducing vulnerability/license-error arrival rates (https://fontawesome.com/icons/battery-three-quarters?style=solid)
- Toolbox (https://fontawesome.com/icons/toolbox?style=solid) for autofixing all vulnerabilities
- Tools https://fontawesome.com/icons/tools?style=solid
- Superpowers (https://fontawesome.com/icons/superpowers?style=brands)
- Plug (https://fontawesome.com/icons/plug?style=solid)
- Bomb (https://fontawesome.com/icons/bomb?style=solid)
- File-contract (https://fontawesome.com/icons/file-contract?style=solid)
- ID card (https://fontawesome.com/icons/id-card?style=regular)
- Prescription (https://fontawesome.com/icons/file-prescription?style=solid)
    <h3>Developer Debug</h3>
    will be removed
        <ol>
          <li>Debug until powerups: "r" raises dropping speed</li>
          <li>Debug until powerups: "l" lowers dropping speed</li>
          <li>Debug until powerups: "c" clears bottom blocks</li>
        </ol>
    """
    end

end
