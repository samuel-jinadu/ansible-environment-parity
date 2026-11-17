docker stop python-alpine-target
docker rm python-alpine-target
docker run -d --name python-alpine-target python:3.14.10-alpine3.24 sleep infinity