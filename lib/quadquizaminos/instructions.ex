defmodule Quadquizaminos.Instructions do

    def game_instruction() do
    """
    ##1. THE BASICS
    <p>Predictably patterned blocks will fall from the game's sky. It's your 
    job to spin these blocks mid air to achieve a perfect fit on the game's ground level.</p>
        <ul>
            <li>LEFT ARROW moves the block array leftwards</li>
            <li>RIGHT ARROW moves the block array rightwards</li>
            <li>UP ARROW pivots the block array 90 degrees</li>
        </ul>
    <p>Once an entire row worth of empty spaces are filled with blocks, that row 
    will disappear and your score will be suddenly flush with points. Conversely, if too
    many blocks accumulate vertically and extend past the skyline at the top of the game 
    screen, it's lights out for you. Budget space and time wisely.</p>
    <p>Think of it this way: the game ends when you go out of business because your supply chain
    got too long and all the vulnerabilities you swept under the rug came back to haunt you.</p>

    ##2. POWER UPS
    <p>In their infinite wisdom, the game developers have seen fit to bestow you with 
    super human power ups. Simply press SPACE and correctly answer some real world trivia
    questions to access one of the following wildly effective tools:</p>
        <sl>
            <li><i class="fas fa-plus-square"></i> add a block - useful to fill in holes</li>
            <li><i class="fas fa-minus-square"></i> remove a block - useful to remove problem blocks</li>
            <li><i class="fas fa-arrows-alt"></i> move a block - helpful both to get a block 'out of the way' and to fill in hole</li>
            <li><i class="fas fa-eraser"></i> clear all blocks - use in attacked or sued, helpful if supply chain gets too long</li>
            <li><i class="fas fa-fast-forward"></i> speed up - needed if lawsuit is slowing your business</li>
            <li><i class="fas fa-fast-backward"></i> slow down - necesary if attacked, useful if game is going too fast</li>
            <li><i class="fas fa-wrench"></i> fix a vulnerability</li>
            <li><i class="fas fa-screwdriver"></i> fix a licensing issue</li>
            <li><i class="fas fa-hammer"></i> remove all vulnerabilities</li>
            <li><i class="fas fa-tape"></i> remove all licensing issues</li>
            <li><i class="fab fa-superpowers"></i> Superpower - exchange for any other powerup</li>
         </sl>
      <p>What? You don't need no stinkin' Power Ups? Guess again.</p>       
     ##3. CATASTROPHIC VULNERABILITIES
     <p>As much as we all wish this was the Atari in your parents' basement, this is the RSA Sandbox
     -- a venue to explore the vulnerabilities that haunt modern cyber security. Accordingly, we've built
     in a few little hiccups along the way to get you thinking about the supply chain of your block arrays.</p>
     <p>During the game, you may notice a few little hiccups that make it nigh on impossible to continue
     without earning a power up or two. Here are some of the fun little challenges life will throw your way:</p>
         <ol>
            <li>vulnerabilities (potential security holes in an otherwise functioning security paradigm)</li>
                <ul>
                    <li>any vulnerability in a row will prevent it being cleared.</li>
                    <li>vulnerabilities make it more likely that you'll be hit with a cyber attack (see below).</li>
                    <li>a vulnerability's arrival is a function of game time and wrong answers to trivia questions.</li>
                    <li>you will recognize a vulnerability on sight</li>
                        <ul>
                            <li>Known vulnerabilities are yellow/gray blocks that appear either in dropping blocks
                                or in uncleared blocks at the bottom.</li>
                            <li>Invisible vulnerabilities (zero days) are white-on-white blocks. If you see one, 
                                you'd better get your power ups in order.</li>
                        </ul>
                 <ul>
            <li>licensing issues (extraneous blocks that gunk up the works)</li>
                <ul>
                    <li>licensing issues are brown/grey blocks that also prevent a row from being cleared.</li>
                    <li>the more license issues, the greater the likelihood of a lawsuit (see below).</li>
                    <li> like vulnerabilities, license issues are a function of game time and wrong answers 
                        to trivia questions</li>
                </ul>
            <li>cyber attacks(rapid changes in operating conditions that take over entire sections
                of the gameboard and speed the game up uncontrollably)</li>
                <ul>
                    <li>ignore enough (5) vulnerabilities in your block array supply chain and you'll be in 
                        for a nasty surprise</li>
                    <li>the game will accelerate to its fastest speed and an entire line of exploits
                        will magically appear on your screen preventing operations. Hit the space bar!</li>
                </ul>
            <li>licensing lawsuits (tiresome procedures that gum up entire sections of the game board
                and slow the game to a snail's pace)</li>
                <ul>
                    <li>not only will the game slow down to a snail's pace, but a fresh coat of pesky brown/grey injunctions
                        will festoon your existing block arrays. Hit the space bar!</li>
                </ul>
        </ol>
    ##4. SCORING
        <p>Points are scored in several ways:</p>
            <ol>
                <li>chronological longevity / block drops</li>
                <li>rows cleared</li>
                <li>questions answered</li>
             </ol>
        <p>The amount of points scored is also influenced by game conditions.
           For instance, the value of clearing a row
           raises exponentially with the number of rows cleared at once.</p>
    ##5. PRO TIPS  
        <p>tetris vs quiz</p>
                 <p>just like in real life, it is sometimes expedient
                    to defer patches due to more imediate revenue needs,
                    sometimes leaving vulnerability or license issues in place lets you build rows
                    that can be cleared at once (since fix/add/delete/move/...
                    are done while game is paused)
                    - but be careful, since it also increases you likelihood
                    of a cyberattack or lawsuit.</p>
                 <p>It's not an easy tradeoff.</p>
                 <p>The game is not tilted towards fixing - you will get a lower
                    score if you spend all your time fixing.
                    Conversely you will likely go out of business due to
                    a cyberattack or lawsuit if ignore them entirely.
                    The best strategy is trading off between the two,
                    and investing in areas that reduce the likelihood
                    (e.g. SBOM, Automation, OpenChain) of them occuring in the first place.</p>
                 <p>Just a little wisdom for thought for those with the ears to hear it.</p>
    ##6. Contest
        <p>
        There will be a 30-min contest on Tuesday 19-May at 11:40 PDT as part of 
        https://www.rsaconference.com/usa/agenda/session/supply-chain-activity-lounge
        </p>
        <p>
        Save the tetrominoes world from supply chain vulnerabilities
        to win pragmatic real world prizes
        including custom cocktail instruction from a superlative mixologist.
        </p>
        <p>
        See <a href="./contest_rules">contest rules</a> and 
        <a href="./contest_prizes">contest prizes</a> for more information. 
        </p>
    """
    end

end
