# Set base image (this loads the Debian Linux operating system)
FROM python:3.12-slim-bookworm

# Update Linux package list and install some key libraries for compiling code
RUN apt-get update && apt-get install -y gcc libffi-dev g++ libssl-dev openssl build-essential graphviz

# Install Latex
RUN apt-get --no-install-recommends install -y texlive-latex-extra

# Install uv
# The installer requires curl (and certificates) to download the release archive
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates
# Download a specific installer
ADD https://astral.sh/uv/0.5.11/install.sh /uv-installer.sh
# Run the installer then remove it
RUN sh /uv-installer.sh && rm /uv-installer.sh
# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin/:$PATH"
# ensure local python is preferred over any built-in python
ENV PATH /usr/local/bin:$PATH

# set the working directory in the container
WORKDIR /app

# Copy the project into the image
ADD . /app

# Install packaegs
RUN uv sync --frozen

# Make the project
RUN uv run make
