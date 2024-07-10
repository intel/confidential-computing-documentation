# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: MIT

FROM squidfunk/mkdocs-material:9.5.27

RUN pip install mkdocs-macros-plugin==1.0.5
RUN pip install mkdocs-git-revision-date-localized-plugin==1.2.6
RUN pip install mkdocs-print-site-plugin==2.5.0
