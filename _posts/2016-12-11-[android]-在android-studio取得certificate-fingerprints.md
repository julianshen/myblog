---
title: "[Android] 在Android Studio取得certificate fingerprints"
date: 2016-12-11 21:27:45 +0800
layout: post
tags: 
    - Android
    - mobiledev
    - Android Studio
---

在使用很多API服務像是Google的API或是Facebook的API, 常常會需要拿簽署APK的Key的signature登錄,
取得這sigature的方法有很多種, 剛學到一種是直接可以從Android studio的Gardle選單內取得的, 方法如下:

Gradle->(Project name)->Tasks->singningReports

{% youtube D1HwAnk49xU %}
