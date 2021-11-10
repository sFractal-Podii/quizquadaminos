## STEPS TO GENERATE LINKEDIN CLIENT SECRETS AND CLIENT ID

Step 1: Login on linked in developers site [developer site](https://www.linkedin.com/developers/)

Step 2: Click on create app, if you have other apps the `My apps` dropdown menu has the option to create app

<img width="968" alt="Screenshot 2021-05-14 at 21 23 35" src="https://user-images.githubusercontent.com/32665021/118314610-0a738300-b4fd-11eb-8c92-f8c320073411.png">

Step 3: Fill in the app name, the linkedin page associated with the app and the other details. NB: The linkedin account with be used to do the app verification, so make sure to use an account you have access to. When you click on create app after filling in all the details, your client secrets and client ID will be generated automatically.

<img width="952" alt="Screenshot 2021-05-14 at 21 24 30" src="https://user-images.githubusercontent.com/32665021/118314792-4c9cc480-b4fd-11eb-82b1-7098d6269c64.png">


Step 4: Verify your App under settings before moving to the next steps. This will enable you to make successful requests to linkedin

<img width="768" alt="Screenshot 2021-05-14 at 21 30 15" src="https://user-images.githubusercontent.com/32665021/118314918-7e159000-b4fd-11eb-8c5d-a964e764f9c9.png">

 
Step 5: Under Auth tab you can view the client ID and secrets

<img width="852" alt="Screenshot 2021-05-14 at 21 45 27" src="https://user-images.githubusercontent.com/32665021/118315244-f11f0680-b4fd-11eb-962b-3bc9a15b894c.png">


Step 6: Add redirect URL replace this `http://localhost:4000/auth/linkedin/callback` with your redirect url `path/to/auth/linkedin/callback`

<img width="726" alt="Screenshot 2021-05-14 at 21 33 54" src="https://user-images.githubusercontent.com/32665021/118315270-f8deab00-b4fd-11eb-9e48-22e90d864e72.png">


Step 7: Enable sign in with linkedin under the products tab
 
<img width="793" alt="Screenshot 2021-05-14 at 21 31 36" src="https://user-images.githubusercontent.com/32665021/118315306-05630380-b4fe-11eb-8b49-4be80bf3cb5a.png">


Step 8: After the Sign In with LinkedIn product is successfully added, your App's OAuth 2.0 scopes will reflect the new permissions granted. Simply go to the Auth tab and scroll down to the bottom.

<img width="812" alt="Screenshot 2021-05-14 at 21 32 43" src="https://user-images.githubusercontent.com/32665021/118315395-23c8ff00-b4fe-11eb-8ead-1d322a9742d2.png">

Add the client secrets and client id to your `releases.exs` together with the other linkedin authentication configuration

```
config :ueberauth, Ueberauth,
  providers: [
    linkedin: {Ueberauth.Strategy.LinkedIn, [default_scope: "r_liteprofile r_emailaddress"]}
  ]

config :ueberauth, Ueberauth.Strategy.LinkedIn.OAuth,
  client_id: "",
  client_secret: ""
  
  ```
  
