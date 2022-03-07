#!/bin/sh
./prod/rel/quadquizaminos/bin/quadquizaminos eval Quadquizaminos.ReleaseTask.createdb
./prod/rel/quadquizaminos/bin/quadquizaminos eval Quadquizaminos.ReleaseTask.migrate
./prod/rel/quadquizaminos/bin/quadquizaminos start
