# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: MIT

FROM squidfunk/mkdocs-material:9.5.27

WORKDIR /tmp

COPY requirements.txt /tmp/requirements.txt

# Install additional MkDocs plugins
RUN pip install -r requirements.txt

ENTRYPOINT ["/sbin/tini", "--", "mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]
