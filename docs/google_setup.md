## GET GOOGLE CLIENT ID AND SECRETS

This documents gives an overview of how one can create the client_id and client_secrets from google.


### Set up Oauth Consent Screen

Click on this [link](https://console.cloud.google.com/apis/credentials) then select the OAuth consent screen option

![Screenshot 2021-04-28 at 11 08 47](https://user-images.githubusercontent.com/32665021/116370998-a15cf180-a813-11eb-845d-2f316c15f196.png)


Then add App information click save and continue

![Screenshot 2021-04-28 at 11 13 46](https://user-images.githubusercontent.com/32665021/116371251-e6812380-a813-11eb-9122-fa0e1e9bb23d.png)


Under scopes, I did not add anything click save and continue 

![Screenshot 2021-04-28 at 11 16 58](https://user-images.githubusercontent.com/32665021/116371460-1af4df80-a814-11eb-872f-6d32fdfa310b.png)


I added test users as the publishing status was testing then click save and continue and proceed to the summary page

![Screenshot 2021-04-28 at 11 17 28](https://user-images.githubusercontent.com/32665021/116373318-e1bd6f00-a815-11eb-80f6-49d269213d2c.png)


Once this is set you can change the publishing status by clicking the publish app button

![Screenshot 2021-04-28 at 11 38 01](https://user-images.githubusercontent.com/32665021/116373788-5a243000-a816-11eb-996f-f4fb9455d628.png)


### Generating client_id and client_secrets

Access the google console [here](https://console.cloud.google.com/apis/credentials) and on the left pane select credentials.

click create credentials and select OAuth client ID

<img width="1226" alt="credentials" src="https://user-images.githubusercontent.com/32665021/116368545-1da20580-a811-11eb-909d-4d7acb00e79a.png">

Select application type as web application

<img width="1034" alt="application_type" src="https://user-images.githubusercontent.com/32665021/116368697-47f3c300-a811-11eb-957e-a0a87f00bb19.png">


Fill in the name and add URl then click create

<img width="1205" alt="details" src="https://user-images.githubusercontent.com/32665021/116368720-4f1ad100-a811-11eb-8fb2-00d67d5de4c6.png">


Then you should have your oauth client created with the client_id and client_secrets

<img width="1074" alt="client_id_secrets" src="https://user-images.githubusercontent.com/32665021/116368742-5641df00-a811-11eb-86a2-4a14260d48fc.png">

