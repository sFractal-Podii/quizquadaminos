#!/bin/sh
./prod/rel/QuadBlockQuiz/bin/QuadBlockQuiz eval QuadBlockQuiz.ReleaseTask.createdb
./prod/rel/QuadBlockQuiz/bin/QuadBlockQuiz eval QuadBlockQuiz.ReleaseTask.migrate
./prod/rel/QuadBlockQuiz/bin/QuadBlockQuiz start
