#!/bin/sh
./rel/quadblockquiz/bin/quadblockquiz eval Quadblockquiz.ReleaseTask.createdb
./rel/quadblockquiz/bin/quadblockquiz eval Quadblockquiz.ReleaseTask.migrate
./rel/quadblockquiz/bin/quadblockquiz start
