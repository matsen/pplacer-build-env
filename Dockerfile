FROM debian:jessie
ENV REFRESHED_AT 2014-07-23

MAINTAINER Brian Claywell <bclaywel@fhcrc.org>

# pplacer-builder
#
# A dockerized builder for the pplacer suite.
# See http://matsen.github.io/pplacer/compiling.html

# Set debconf to noninteractive mode.
# https://github.com/phusion/baseimage-docker/issues/58#issuecomment-47995343
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install packages. Note that opam is available in jessie and doesn't
# have to be installed separately.
RUN apt-get update -q && \
    apt-get install -y -q --no-install-recommends \
    camlp4-extra \
    gawk \
    libgsl0-dev \
    libsqlite3-dev \
    libz-dev \
    m4 \
    make \
    ocaml \
    opam \
    patch \
    git && \
    apt-get clean -q

RUN useradd -m -d /home/builder -p builder builder

WORKDIR /home/builder
USER builder
ENV HOME /home/builder

# Initialize opam.
RUN opam init && \
    opam config setup -a

# Install version 3.12.1 of the OCaml compiler version if it's not active.
RUN command -v ocamlc && \
    ( ocamlc -version | grep -q 3.12.1 ) || \
    opam switch install 3.12.1

# Configure pplacer's opam repository.
RUN opam repo add pplacer-deps http://matsen.github.com/pplacer-opam-repository && \
    opam update pplacer-deps

# Clone the pplacer repository.
RUN git clone git://github.com/matsen/pplacer
WORKDIR /home/builder/pplacer

# Install pplacer's dependencies.
RUN cat opam-requirements.txt | xargs opam install -y

# Install the run script.
ADD docker-entrypoint.sh /docker-entrypoint

# Export the build output directory.
VOLUME /home/builder/pplacer/bin

ENTRYPOINT ["/docker-entrypoint"]
CMD ["/docker-entrypoint", "/usr/bin/make"]
