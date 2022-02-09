# instead of 14, we use 34. I am not aware of any :14 container (nothing below :32 for ocaml it seems)
FROM ocaml/opam:fedora-34-opam
# FROM ocaml/opam:fedora-34-ocaml-4.09

USER root

# https://github.com/erimcg/ChewTPTP/tree/master/ChewTPTP
ARG YICES=yices-1.0.13-x86_64-pc-linux-gnu.tar.gz
# ARG GMP=gmp-4.2.2.tar.gz

COPY setup-fedora.sh varsrc /

RUN chmod +x /setup-fedora.sh && /setup-fedora.sh
RUN rm /setup-fedora.sh

# we do need java for the aggregation
COPY install-java.sh /
RUN chmod +x /install-java.sh && /install-java.sh
RUN rm /install-java.sh

# I call this extra to allow caching to work on the ocaml setup and stuff.
COPY setup-crest.sh offline/$YICES offline/install-yices.sh /
RUN chmod +x /setup-crest.sh && /setup-crest.sh
RUN rm /setup-crest.sh

COPY setup-ctags.sh /
RUN chmod +x /setup-ctags.sh && /setup-ctags.sh
RUN rm /setup-ctags.sh

COPY setup-cccd.sh offline/cccd.zip /
RUN chmod +x /setup-cccd.sh && /setup-cccd.sh
RUN rm /setup-cccd.sh

# The goal is to have all downloads to be completed here (except for the yices installer shell script. This
# May be a todo)
# Furthermore, all the previeous steps consume >5min and i have to perform a lot of interface mods from now on...
COPY install-cccd.sh varsrc-extra /
RUN chmod +x /install-cccd.sh && /install-cccd.sh
RUN rm /install-cccd.sh

COPY patching.sh cccd.new /
RUN chmod +x /patching.sh && /patching.sh
RUN rm /patching.sh
# TODO: move all rms to a cleanup script

RUN echo "TODO: update source files"

WORKDIR /home/fedora-user

# trying caching
COPY test-cccd.sh validate-test.py kraw-expected.csv /
RUN chmod +x /test-cccd.sh && /test-cccd.sh
RUN rm /test-cccd.sh

# USER fedora-user # keep root for inspection
CMD ["/bin/bash"]