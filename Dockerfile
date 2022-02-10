# This dockerfile builds everything and runs a test. The buildfiles are largely removed
# However, this dockerfile is not designed to produce a "minimal" image. It was the result of a long process
# of patching and cleaned up afterwards. Furthermore, there is no real need to clean it up further (at least for me)
# the size, while large, is sufficient for running cccd.

# instead of 14, we use 34. I am not aware of any :14 container (nothing below :32 for ocaml it seems)
FROM ocaml/opam:fedora-34-opam
# FROM ocaml/opam:fedora-34-ocaml-4.09

# root for analysis
USER root
WORKDIR /home/fedora-user

ARG OCAML_VERSION=3.09.0 HOME_FOLDER=/home/fedora-user
COPY scripts/setup-fedora.sh data/varsrc /
RUN chmod +x /setup-fedora.sh && /setup-fedora.sh

ARG CCCD_DIRTY="$HOME_FOLDER/dk-crest-java/trunk/ dk-crest-java --username dek782@gmail.com/crestClean"

ARG JAVA_TARGET=java-1.8.0-openjdk-devel.x86_64
# we do need java for the aggregation
COPY scripts/install-java.sh /
RUN chmod +x /install-java.sh && /install-java.sh

# https://github.com/erimcg/ChewTPTP/tree/master/ChewTPTP
ARG YICES=yices-1.0.13-x86_64-pc-linux-gnu.tar.gz
# I call this extra to allow caching to work on the ocaml setup and stuff.
COPY scripts/setup-crest.sh offline/$YICES offline/install-yices.sh /
RUN chmod +x /setup-crest.sh && /setup-crest.sh

COPY scripts/setup-ctags.sh /
RUN chmod +x /setup-ctags.sh && /setup-ctags.sh

COPY scripts/setup-cccd.sh offline/cccd.zip /
RUN chmod +x /setup-cccd.sh && /setup-cccd.sh

# use "YES" to run (anything else will be false); without will not produce any ratings, but at least it breaks free from dirty patching
ARG DO_CIL_PATCH="YES"
# The goal is to have all downloads to be completed here (except for the yices installer shell script. This
# May be a todo)
# Furthermore, all the previeous steps consume >5min and i have to perform a lot of interface mods from now on...
COPY scripts/install-cccd.sh /
RUN chmod +x /install-cccd.sh && /install-cccd.sh

COPY scripts/patching.sh data/cccd.new /
RUN chmod +x /patching.sh && /patching.sh

RUN echo "TODO: update source files"

ENV CCCD_INPUT="$CCCD_DIRTY/sourceFiles/input"
ARG TEST_NAME="$CCCD_INPUT/kraw"
# trying caching
COPY scripts/run-cccd.sh scripts/test-cccd.sh testing/validate-test.py testing/kraw-expected.csv /
RUN chmod +x /run-cccd.sh && chmod +x /test-cccd.sh && /test-cccd.sh

# cleanup will remove all scripts but the run script
COPY scripts/cleanup.sh /
RUN chmod +x /cleanup.sh && /cleanup.sh

# USER fedora-user # keep root for inspection
ENTRYPOINT [ "/bin/bash", "/run-cccd.sh" ]

LABEL description="This image is used to get cccd running even though basically none of its dependencies are easily available today." url_ccd="https://web.archive.org/web/20150921003732/https://www.se.rit.edu/~dkrutz/CCCD/index.html?page=install"

# Here we could extract the build container. however, this did not work the first time and so i am scared and refer to a cleanup