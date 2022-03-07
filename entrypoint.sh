#!/bin/sh
./prod/rel/quadblockquiz/bin/quadblockquiz eval Quadblockquiz.ReleaseTask.createdb
./prod/rel/quadblockquiz/bin/quadBlockquiz eval Quadblockquiz.ReleaseTask.migrate
./prod/rel/quadblockquiz/bin/quadblockquiz start
