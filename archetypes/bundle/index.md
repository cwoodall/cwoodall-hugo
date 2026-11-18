---
title: "{{ replace (replaceRE `^\d{4}-\d{2}-\d{2}-` "" .Name) "-" " " | title }}"
date: {{ .Date }}
draft: true
---

Intro paragraph (shown on the list page).

<!--more-->

<!--
Drop photos/videos into this folder, run:
    scripts/prep-media.sh <this folder>/*
then reference them by file name:

  ![Alt text](photo.jpg "Optional caption")

  {{< gallery >}}
  ![](a.jpg)
  ![](b.jpg)
  {{< /gallery >}}

  {{< video "clip.mp4" >}}

A file named cover.jpg (or cover.png …) becomes the hero image automatically.
-->
