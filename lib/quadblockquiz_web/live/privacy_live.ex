defmodule QuadblockquizWeb.PrivacyLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
            <h1 class="heading-1 text-center mt-6">Privacy Policy</h1>
            <p class="font-bold text-center">Version 1.0.0 (last updated 6-May-2021)</p>

            <p class="mt-6">sFractal takes your privacy as seriously
            as you do.
            We want to give you control over the little information we collect from you
            and work transparently to keep that information no longer than necessary.

            This Privacy Policy describes the policies and procedures we apply to the
            use and disclosure of your information we collect
            when you interact with our game. We also elaborate your privacy rights
            and how the law protects you.

            We use your personal data to provide and improve the game.
            By using the service,
            you agree to the collection
            and use of information in accordance with this Privacy Policy.
            Parts of this Privacy Policy has been created
            with the help of the Privacy Policy Generator.</p>


            <h2 class="heading-3 mt-6">What data is collected by Quadblockquiz?</h2>
            We are only collecting publicly accessbile information.
            If you login using our anonymous feature,
            we are collecting/keeping no information at all.
            If you login using OAUTH from GitHub, Google, Twitter, LinkedIn
            then we are only keeping enough information to display your score,
            and to contact you should you win a prize.

            <h2 class="heading-3 mt-6">How is my data used by Quadblockquiz?</h2>
            We use your data to operate, maintain, and improve our game.
            In particular, your identiy (if provided by OAUTH from GitHub,
            Google, Twitter, or LinkedIn) is used to display your score
            on the Leaderboard and on the Context Board.
            We may use your contact information from OAUTH to inform you of prizes
            should you win our contest.

            <h2 class="heading-3 mt-6">How is my data shared?</h2>
            Your data
            (which we believe to only be publicly accessible information)
            will not be shared other than
            (1) if we are required to do so by law
            (2) to establish, exercise, or defend our legal rights
            (3) when we believe disclosure is necessary or appropriate to prevent
            physical, fiancial, or other harm
            (4) in conjunction with an investigation of suspected or actual illegal activity
            (5) to protect the rights, property, or safety of sFractal or it's users.

            <h2 class="heading-3 mt-6">Information from Third-Party Social Media Services</h2>
            We allow you to create an account
            and log in to use the game
            through the following third-party Social Media Services:
            <li>GitHub </li>
            <li>Google </li>
            <li>Facebook </li>
            <li>Twitter </li>
            <li>LinkedIn </li>
            If you decide to register through
            or otherwise grant us access to a third-party Social Media Service,
            We may collect personal data that is already associated
            with your third-party Social Media Service's account,
            such as your name, or your email address,
            associated with that account.

            <h2 class="heading-3 mt-6">What about cookies?</h2>
            We may use techologies such as cookies, local storage,
            web sessions, websockets
            and other automated tecnologies on our websites.
            We use these technologies for a number of reasons
            including authentication, authorization, security,
            and diagnostics.

            You can control cookies through your browswer settings
            and other tools.
            Note that rejecting cookies may affect your ability
            to interact with the website.

            <h2 class="heading-3 mt-6">How do I access or delete my data?</h2>
            Contact: Quadblockquiz@googlegroups.com

            <h2 class="heading-3 mt-6">Retention</h2>
            To the extent possible, we keep no data longer than necessary;
            and will delete all data within one year unless we have
            the owner's consent to retain for a specific purpose
            (e.g. bragging rights to remain on Leaderboard).

            <h2 class="heading-3 mt-6">How do we protect your information?</h2>
            We intend to only collect publicly available information
            and we maintain administrative, technical, and physical
            safeguards to protect any data we maintain against
            accidental, unlawful, or unauthorized
            destruction, loss, adulteration, access, distortion, or use.

            <h2 class="heading-3 mt-6">Children under 13</h2>
            This website is intended for a general audience
            and is not directed at children.
            We do not knowlingly collect personal information
            online from indivuals under the age of 13
            or such other age as may be directed by applicable law.

            <h2 class="heading-3 mt-6">Links to Other Websites</h2>
            Our Service may contain links to other websites
            that are not operated by Us.
            If You click on a third party link,
            You will be directed to that third party's site.
            We strongly advise You to review the Privacy Policy
            of every site You visit.

            We have no control over and assume no responsibility
            for the content, privacy policies or practices
            of any third party sites or services.

            <h2 class="heading-3 mt-6">Changes to this policy</h2>
            sFractal may amend this policy from time to time.
            We encourage you to regularly check this page to review any changes.
            Near the top of this page, we will indicate when
            it was most recently updated.

            <h2 class="heading-3 mt-6">Security of Your Personal Data</h2>
            The security of Your Personal Data is important to Us,
            but remember that no method of transmission over the Internet,
            or method of electronic storage is 100% secure.
            While We strive to use commercially acceptable means
            to protect Your Personal Data,
            We cannot guarantee its absolute security.

    """
  end
end
