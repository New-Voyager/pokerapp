SET DEFAULT_DOCKER_NET=game
SET API_SERVER_IMAGE=gcr.io/voyager-01-285603/api-server:0.1.49
SET GAME_SERVER_IMAGE=gcr.io/voyager-01-285603/game-server:0.1.26
SET BOTRUNNER_IMAGE=gcr.io/voyager-01-285603/botrunner:0.1.43
SET TIMER_IMAGE=gcr.io/voyager-01-285603/timer:0.0.1

SET NATS_SERVER_IMAGE=gcr.io/voyager-01-285603/nats-server:0.1.20
SET REDIS_IMAGE=gcr.io/voyager-01-285603/redis:6.0.9
SET POSTGRES_IMAGE=gcr.io/voyager-01-285603/postgres:12.5
del .env
echo API_SERVER_IMAGE=%API_SERVER_IMAGE% >> .env
echo GAME_SERVER_IMAGE=%GAME_SERVER_IMAGE% >> .env
echo NATS_SERVER_IMAGE=%NATS_SERVER_IMAGE% >> .env
echo REDIS_IMAGE=%REDIS_IMAGE% >> .env 
echo POSTGRES_IMAGE=%POSTGRES_IMAGE% >> .env
echo TIMER_IMAGE=%TIMER_IMAGE% >> .env
