defmodule QuadquizaminosWeb.PrivacyLive do
    use Phoenix.LiveView

    def render(assigns) do
        ~L"""
        <h1>Privacy Policy</h1>
        <h3>Version 1.0.0 (last updated 6-May-2021)</h3>

        sFractal knows you take you privacy seriously
        and we do too.
        We attempt to collect as little information as possible,
        be transparent,
        keep the information no longer than necessary,
        and give you control over what information we collect about you.

        This Privacy Policy describes Our policies and procedures on the
        collection, use and disclosure of Your information
        when You use the Service and tells You about Your privacy rights
        and how the law protects You.

        We use Your Personal data to provide and improve the Service.
        By using the Service,
        You agree to the collection
        and use of information in accordance with this Privacy Policy.
        Parts of this Privacy Policy has been created
        with the help of the Privacy Policy Generator.


        <h2>What data is collected by QuadBlockQuiz?</h2>
        We believe we are only collecting publicly accessbile information.
        If you login using our anonymous feature,
        we are collecting/keeping no information at all.
        If you login using OAUTH from GitHub, Google, Twitter, LinkedIn
        then we are only keeping enough information to display your score,
        and to contact you shoudl you win a prize.

        <h2>How is my data used by QuadBlockQuiz?</h2>
        We use your data to operate, maintain, and improve our services.
        In particular, your identiy (if provided by OAUTH from GitHub,
        Google, Twitter, or LinkedIn) is used to display your score
        on the Leaderboard and on the Context Board.
        We may use your contact information from OAUTH to inform you of prizes
        should you win our contest.

        <h2>How is my data shared?</h2>
        Your data
        (which we believe to only be publicly accessible information)
        will not be shared other than
        (1) if we are required to do so by law
        (2) to establish, exercise, or defend our legal rights
        (3) when we believe disclosure is necessary or appropriate to prevent
        physical, fiancial, or other harm
        (4) in conjunction with an investigation of suspected or actual illegal activity
        (5) to protect the rights, property, or safety of sFractal or it's users.

        Information from Third-Party Social Media Services
        The Company allows You to create an account
        and log in to use the Service
        through the following Third-party Social Media Services:
        GitHub,
        Google,
        Facebook,
        Twitter,
        LinkedIn.
        If You decide to register through
        or otherwise grant us access to a Third-Party Social Media Service,
        We may collect Personal data that is already associated
        with Your Third-Party Social Media Service's account,
        such as Your name, or Your email address,
        associated with that account.

        <h2>What about cookies?</h2>
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

        <h2>How do I access or delete my data?</h2>
        Contact quadblockquiz@googlegroups.com

        <h2>Retention</h2>
        To the extent possible, we keep no data longer than necessary;
        and will delete all data within one year unless we have
        the owner's consent to retain for a specific purpose
        (e.g. bragging rights to remain on Leaderboard).

        <h2>How do we protect your information?</h2>
        We intend to only collect publicly available information
        and we maintain administrative, technical, and physical
        safeguards to protect any data we maintain against
        accidental, unlawful, or unauthorized
        destruction, loss, adulteration, access, distortion, or use.

        <h2>Children under 13</h2>
        This website is intended for a general audience
        and is not directed at children.
        We do not knowlingly collect personal information
        online from indivuals under the age of 13
        or such other age as may be directed by applicable law.

        <h2>Links to Other Websites</h2>
        Our Service may contain links to other websites
        that are not operated by Us.
        If You click on a third party link,
        You will be directed to that third party's site.
        We strongly advise You to review the Privacy Policy
        of every site You visit.

        We have no control over and assume no responsibility
        for the content, privacy policies or practices
        of any third party sites or services.

        <h2>Changes to this policy</h2>
        sFractal may amend this policy from time to time.
        We encourage you to regularly check this page to review any changes.
        Near the top of this page, we will indicate when
        it was most recently updated.

        <h2>Security of Your Personal Data</h2>
        The security of Your Personal Data is important to Us,
        but remember that no method of transmission over the Internet,
        or method of electronic storage is 100% secure.
        While We strive to use commercially acceptable means
        to protect Your Personal Data,
        We cannot guarantee its absolute security.

"""
      end
end
