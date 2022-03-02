# Contributing

This project uses [semantic versioning](https://semver.org/) as much as we can

## Issue tracking

We use github issues to track issues , checkout [the project board](https://github.com/sFractal-Podii/quizquadaminos/projects/1) for issues

All issues have priorities with `A` being the highest priority

## Development

If you would like to contribute code to the project, here is the workflow you need to be aware of:

1. We maintain linear git history by rebasing against the develop branch
1. We squash all commits for each pull request

### Rebasing against the develop

If you are working from the main repository then you need to follow the following steps

1. fetch the latest changes from the origin using `git fetch origin`
1. create a branch based off the develop branch `git checkout -b <your-branch>`
1. work on the branch and create a pull request, commit as much as you wish at this stage
1. once your work is ready to be merged we need to rebase it against the development branch, we can squash commits at the same time

```shell
git fetch origin
git rebase orign/develop -i
```

To squash the commits replace the word `pick` with the letter `s` on the following commits. Watch [this video](https://youtu.be/jIK-fuFpK2I) to see how to do it

## Deployment strategy

see [deployment](./deployment.md) for deployment options and how to deploy

## working with questions
Quadblockquiz includes both playing quadblocks
and answering questions
to gain points and powerups. 

### Adding questions

We currently have two folders for adding questions, it can be on the `qna` directory or the `courses` both on the project root directory.
Contest questions are currently on the `qna` directory while `courses` contains questions for a classroom setup type of questions

To add a question, you will need to add a markdown file which should meet the following conditions

1.  It needs to define the question type

This is defined in the 'header' of the file. The two questions types currently allowed are `free-form` and `multi-choice` (take note of the `-`).
The header is then followed by three dashes

#### Example

```markdown
%{
type: "free-form"
}

---
```

2.  Needs to clearly define the question

The main question is marked by the first level markdown header (using one `#`) followed by the word question

#### Example

```markdown
## Software Bill of Materials

A “Software Bill of Materials” (SBOM) is
effectively a nested inventory,
a list of ingredients that make up

# Question:

What does SBOM stand for?
```

Anything before the `answers` header is considered part of the question

3.  The answers need to be clearly defined

Answers are marked by second level markdown header (that is two `#`) with the word `answers`

For multichoice answers, we use the markdown list (`-`) to show the options. The position of the correct answer is counted from 0 being the first option (this information will be used later when generating/updating answers)

#### Example

    ```markdown
    ## Answers
    - Security Bungles Obfuscate Mission
    - Software Bill of Materials
    - Special Bureau of Meteorology
    - Security Bill of Materials
    ```

4.  Scores should be provided

We need to provide the score for both right score and wrong score

#### Example

    ```markdown
    ## Score
    - Right:25
    - Wrong:5

    ```

5.  Power up for the question

This determines what powerup the user gets whenever they get the correct answer. Valid power ups are - deleteblock - addblock - moveblock - clearblocks - speedup - slowdown - fixvuln - fixlicense - rm_all_vulns - rm_all_lic_issues - superpower

#### Example

```markdown
## Powerup

DeleteBlock
```

### Generating answers

There is a convenience tasks that generates default answers (0 for multichoice and "secret" for free-form questions)

```shell

$ mix gen.answers

Compiling 67 files (.ex)
Generated Quadblockquiz app

12:57:05.448 [info]  Generating answers for qna..

12:57:05.483 [info]  Answers written to qna/answers.json

12:57:05.483 [info]  Generating answers for courses..

12:57:05.493 [info]  Answers written to courses/answers.json

```

If you run this command without any arguments, it will generate answers for both `qna` and `courses` directories.
The generated answers do not override any previous answer if there was any existing answers

To generate answers for a single directory only, pass in the directory name as an argument to the command

```shell
$ mix gen.answers qna # genratates only for the qna folder

12:57:05.448 [info]  Generating answers for qna..

12:57:05.483 [info]  Answers written to qna/answers.json

```

```shell
$ mix gen.answers courses # genratates only for the courses folder

12:57:05.448 [info]  Generating answers for courses..

12:57:05.483 [info]  Answers written to courses/answers.json

```

#### Customising the answers

Once the default answers have been generated, we can open the `answers.json` file and provide the correct answers. Note that the answers you provide will not be overridden by the next `mix gen.answers`

For development purposes, the first multichoice answer is always the correct answer, the word "secret" is always the answer to a `free-form` question

If you add a new question to either `qna` or `courses` directory then running `mix gen.answers` will add the default answer to only the new files you have added (assuming you had generated the answers before adding those two files)

## Misc Convenience make tasks

This project includes a couple of convenience `make` tasks. To get the full list
of the tasks run the command `make targets` to see a list of current tasks. For example

```shell
Targets
---------------------------------------------------------------
compile                compile the project
deploy-existing-image  creates an instance using existing gcp docker image
docker-image           builds docker image
format                 Run formatting tools on the code
lint-compile           check for warnings in functions used in the project
lint-format            Check if the project is well formated using elixir formatter
lint-unused            Check if there is unused functions
lint                   Check if the project follows set conventions such as formatting
push-and-serve-gcp     creates docker image then push to gcp and launches an instance with the image
push-image-gcp         push image to gcp
release                Build a release of the application with MIX_ENV=prod
test                   Run the test suite
update-instance        updates image of a running instance
```


## Redesign of the project layout

Currently the project is being redesigned using [tailwindcss framework](https://tailwindcss.com) which enables us to build complex responsive layouts. 

At the moment the project is using both `phoenixcss` and `tailwindcss` framework. This was done, so that we couldn't affect the agile methodology adapted earlier and also not to affect the already existing pages layouts that are using phoenixcss framework. 

#### Steps to follow when redesigning a page using tailwindcss framework

1. Use Prototype design layouts of the pages that are drawn on [figma](https://www.figma.com/file/vAUOkmrAHEo4Q2q1JtW9e1/quizquadaminos?node-id=156%3A2). 
   Mobile design layout are available under `Android google pixel` and design layout for medium to large screens are available under `Web page` .

2. Under `router.ex` add the path of the page you are redesigning inside the scope that is piped through tailwind_layout i.e

    ```
    scope "/", QuadblockquizWeb do
    pipe_through [:browser, :tailwind_layout]

    get "/how-to-play", PageController, :how_to_play
    live "/contest_rules", ContestRules
    live "/leaderboard", LeaderboardLive
    end

   ```


 
