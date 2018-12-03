FROM gapsystem/gap-docker

MAINTAINER Nathan Carter <ncarter@bentley.edu>

COPY --chown=1000:1000 . $HOME/inst/gap-4.10.0/pkg/jupyterviz

USER gap
ENV HOME /home/gap
ENV GAP_HOME /home/gap/inst/gap-4.10.0
ENV PATH ${GAP_HOME}/bin:${PATH}

WORKDIR /home/gap

CMD ["bash"]
