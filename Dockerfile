FROM gapsystem/gap-docker-master:latest

MAINTAINER Nathan Carter <ncarter@bentley.edu>

COPY --chown=1000:1000 . $HOME/inst/gap-master/pkg/jupyter-viz

WORKDIR ./tst/

