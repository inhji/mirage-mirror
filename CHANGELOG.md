# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](Https://conventionalcommits.org) for commit guidelines.

<!-- changelog -->

## [v0.39.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.38.1...v0.39.0) (2022-01-05)




### Features:

* update user profile

### Bug Fixes:

* remove old theme variables

## [v0.38.1](http://10.0.0.11/inhji/mirage2.git/compare/v0.38.0...v0.38.1) (2022-01-05)




### Bug Fixes:

* order_by on home page

## [v0.38.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.37.0...v0.38.0) (2022-01-05)




### Features:

* add in_reply_to field in form and show pages

* add in_reply_to field for note

* add test for about and fix index test

* only run hooks if note is already published

* run hooks on publish

### Bug Fixes:

* footer styles extending to article footer

* complete about page test

* remove webmentions.ex

* Revert "fix: incoporate webmentions to find fucking error"

* more logging tweaks for webmention worker

## [v0.37.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.36.3...v0.37.0) (2022-01-05)




### Features:

* limit logs to 10

## [v0.36.3](http://10.0.0.11/inhji/mirage2.git/compare/v0.36.2...v0.36.3) (2022-01-04)




### Bug Fixes:

* logger error

## [v0.36.2](http://10.0.0.11/inhji/mirage2.git/compare/v0.36.1...v0.36.2) (2022-01-04)




### Bug Fixes:

* incoporate webmentions to find fucking error

## [v0.36.1](http://10.0.0.11/inhji/mirage2.git/compare/v0.36.0...v0.36.1) (2022-01-04)




### Bug Fixes:

* another try to send webmentions

* limit webmention worker to 3 attempts

## [v0.36.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.35.1...v0.36.0) (2022-01-04)




### Features:

* show state and queue for jobs on dashbaord

### Bug Fixes:

* try to find error with empty url

## [v0.35.1](http://10.0.0.11/inhji/mirage2.git/compare/v0.35.0...v0.35.1) (2022-01-04)




### Bug Fixes:

* require Logger in WebmentionWorker

## [v0.35.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.34.1...v0.35.0) (2022-01-04)




### Features:

* add menu to settings page

### Bug Fixes:

* add error handling to

## [v0.34.1](http://10.0.0.11/inhji/mirage2.git/compare/v0.34.0...v0.34.1) (2022-01-04)




### Bug Fixes:

* update link to author hcard

## [v0.34.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.33.7...v0.34.0) (2022-01-04)




### Features:

* move hcard to homepage

## [v0.33.7](http://10.0.0.11/inhji/mirage2.git/compare/v0.33.6...v0.33.7) (2022-01-04)




### Bug Fixes:

* mf2 properties

## [v0.33.6](http://10.0.0.11/inhji/mirage2.git/compare/v0.33.5...v0.33.6) (2022-01-04)




### Bug Fixes:

* remove docs from rel task

## [v0.33.5](http://10.0.0.11/inhji/mirage2.git/compare/v0.33.4...v0.33.5) (2022-01-04)




### Bug Fixes:

* run phx.digest on deploy server

## [v0.33.4](http://10.0.0.11/inhji/mirage2.git/compare/v0.33.3...v0.33.4) (2022-01-04)




### Bug Fixes:

* add cache_Static_manifest again

## [v0.33.3](http://10.0.0.11/inhji/mirage2.git/compare/v0.33.2...v0.33.3) (2022-01-04)




### Bug Fixes:

* add phx-track-static to linked static assets

## [v0.33.2](http://10.0.0.11/inhji/mirage2.git/compare/v0.33.1...v0.33.2) (2022-01-04)




### Bug Fixes:

* remove cache_static_manifest again

## [v0.33.1](http://10.0.0.11/inhji/mirage2.git/compare/v0.33.0...v0.33.1) (2022-01-04)




### Bug Fixes:

* run phx.digest before deploy to include new static assets

## [v0.33.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.32.0...v0.33.0) (2022-01-04)




### Features:

* add h-card + photo

## [v0.32.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.31.0...v0.32.0) (2022-01-04)




### Features:

* add _with_hooks functions for notes

* add scheme option to endpoint

* add static_cache_manifest option to endpoint

## [v0.31.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.30.0...v0.31.0) (2022-01-04)




### Features:

* add NoteHooks module

### Bug Fixes:

* wrong return value for Logger.log/2

## [v0.30.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.29.0...v0.30.0) (2022-01-03)




### Features:

* improve logger a lottt

* initial webmention worker

* Add live dashboard

* add oban queue

## [v0.29.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.28.0...v0.29.0) (2022-01-02)




### Features:

* finish identity tests

## [v0.28.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.27.0...v0.28.0) (2022-01-02)




### Features:

* Add postcss-preset-env

* add user identities

## [v0.27.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.26.0...v0.27.0) (2022-01-01)




### Features:

* add dashboard_controller test

## [v0.26.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.25.0...v0.26.0) (2022-01-01)




### Features:

* add dashboard to show logs

* add clear_logs/0

* add database logging module

* Add webmentions

## [v0.25.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.24.0...v0.25.0) (2021-12-31)




### Features:

* rename deploy alias to push, add new deploy alias

* add head metadata

* clean up page_titles

## [v0.24.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.23.1...v0.24.0) (2021-12-31)




### Features:

* add max width to settings page

* make slug editable

* separate home link

* create color palette from tailwind colors

* unify content links

* make all content links accent2

* add h2 styles again

### Bug Fixes:

* alert styles for live pages

* path to scripts part 2

## [v0.23.1](http://10.0.0.11/inhji/mirage2.git/compare/v0.23.0...v0.23.1) (2021-12-31)




### Bug Fixes:

* path to scripts

## [v0.23.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.22.0...v0.23.0) (2021-12-31)




### Features:

* prevent signup after the first user

* give login screen a max width

* improve alert colors

* clean up unused js

* switch to selfhosted inter font again

## [v0.22.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.21.1...v0.22.0) (2021-12-30)




### Features:

* Add release.ex

## [v0.21.1](http://10.0.0.11/inhji/mirage2.git/compare/v0.21.0...v0.21.1) (2021-12-30)




### Bug Fixes:

* docs logo path

## [v0.21.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.20.0...v0.21.0) (2021-12-30)




### Features:

* small deploy tweaks

* add tzdata

* move all assets to /priv/static

* small tweaks

* add manifest.json to Endpoint config

* add favicon

* feed page

* about page

### Bug Fixes:

* warnings

* re-add mirage logo

## [v0.20.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.19.0...v0.20.0) (2021-12-29)




### Features:

* small improvements

* add create_user/1 support function

* add order_by for note list

### Bug Fixes:

* feeds_test

* notecontroller test

* css file styles overriding inline styles

## [v0.19.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.18.0...v0.19.0) (2021-12-28)




### Features:

* revamp theme

* add note_list_live

* add phoenix_active_link

* add alpinejs, tailwind

* add editor markdown toggle

* add new dark theme

### Bug Fixes:

* markdown editor not saving content lol

## [v0.18.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.17.0...v0.18.0) (2021-12-27)




### Features:

* add rss/atom feeds

* add get_user/0

* add user to notes

* add name, handle and bio fields to user

* small theme tweaks

* show published note feed on homepage

* categorize themes

* add timex

* add about page

### Bug Fixes:

* test regarding homepage

* use slugify_downcase/1 for looking up tags

## [v0.17.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.16.0...v0.17.0) (2021-12-22)




### Features:

* create docs when creating a release

* add docs

## [v0.16.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.15.2...v0.16.0) (2021-12-21)




### Features:

* add public note controller

* add microformats2 actions for notes

### Bug Fixes:

* link styles

* add closing bracket to clean_escapes/1

* line color

## [v0.15.2](http://10.0.0.11/inhji/mirage2.git/compare/v0.15.1...v0.15.2) (2021-12-20)




### Bug Fixes:

* finish note refactor

* clean up editor

## [v0.15.1](http://10.0.0.11/inhji/mirage2.git/compare/v0.15.0...v0.15.1) (2021-12-19)




### Bug Fixes:

* inline code blocks

## [v0.15.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.14.0...v0.15.0) (2021-12-18)




### Features:

* update tags on save, show them for notes

* replace milkdown with prosemirror

## [v0.14.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.13.0...v0.14.0) (2021-12-11)




### Features:

* add NoteTags module

* add ability to remove tags in TagUpdater

* render list content on index page

* remove Show Note title prefix from note show page

* improve line and table colors

## [v0.13.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.12.0...v0.13.0) (2021-12-08)




### Features:

* small design tweaks

### Bug Fixes:

* unique list title errors

* remove IO.inspect calls

## [v0.12.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.11.0...v0.12.0) (2021-12-07)




### Features:

* TagUpdater

* join notes with tags

* add tags

## [v0.11.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.10.1...v0.11.0) (2021-12-05)




### Features:

* move show link to title in entity index table

### Bug Fixes:

* nicer border colors

## [v0.10.1](http://10.0.0.11/inhji/mirage2.git/compare/v0.10.0...v0.10.1) (2021-12-04)




### Bug Fixes:

* milkdown swallowing spaces

## [v0.10.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.9.1...v0.10.0) (2021-12-04)




### Features:

* add referencing lists to Mirage.References

* address lists by slug

* tweak tables, links, colors, forms

### Bug Fixes:

* references coming from milkdown are escaped

## [v0.9.1](http://10.0.0.11/inhji/mirage2.git/compare/v0.9.0...v0.9.1) (2021-12-04)




### Bug Fixes:

* remove fieldset border

## [v0.9.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.8.0...v0.9.0) (2021-12-04)




### Features:

* add proper preloads for notes and lists

* add table styles

* add button styles

* add lists to notes and notes to list <3

* improve editor to work for all forms

* add list slug,  correct list tests from default ones,

### Bug Fixes:

* configure repo to always assume binary_ids

## [v0.8.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.7.0...v0.8.0) (2021-12-04)




### Features:

* a lot of small changes

* add home link

* add references proper

* add theme selector

* move notes to admin

* add lists

* add milkdown editor

* better layout

* add test for showing a single note

* render note content with references

## [v0.7.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.6.0...v0.7.0) (2021-11-29)




### Features:

* switch to urls with slugs instead of ids

## [v0.6.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.5.1...v0.6.0) (2021-11-28)




### Features:

* add get_references/1 and replace_references/2

## [v0.5.1](http://10.0.0.11/inhji/mirage2.git/compare/v0.5.0...v0.5.1) (2021-11-28)




### Bug Fixes:

* set aside autocomplete for now

* warnings

## [v0.5.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.4.1...v0.5.0) (2021-11-28)




### Features:

* simple note search

* markdown rendering

* publish/unpublish notes

* improve alert styles

### Bug Fixes:

* small tweaks

* box-sizing and better header styles

## [v0.4.1](http://10.0.0.11/inhji/mirage2.git/compare/v0.4.0...v0.4.1) (2021-11-28)




### Bug Fixes:

* migrations in wrong order

## [v0.4.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.3.0...v0.4.0) (2021-11-28)




### Features:

* add dummy search endpoint

### Bug Fixes:

* set current version

## [v0.4.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.3.0...v0.4.0) (2021-11-28)




### Features:

* add dummy search endpoint

### Bug Fixes:

* set current version

## [v0.3.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.2.0...v0.3.0) (2021-11-28)




### Features:

* add support for slugs

* add autocomplete lib

* add migration for pg_trgm

* add form styles

* add header styles

* add inter font

* initial layout and css structure

* add _content_menu

* add notes

### Bug Fixes:

* load autocomplete

* css error

## [v0.2.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.1.0...v0.2.0) (2021-11-28)




### Features:

* add support for slugs

* add autocomplete lib

* add migration for pg_trgm

* add form styles

* add header styles

* add inter font

* initial layout and css structure

* add _content_menu

* add notes

### Bug Fixes:

* load autocomplete

* css error

## [v0.2.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.1.0...v0.2.0) (2021-11-28)




### Features:

* add gitconfig

* add rel alias

* add authentication via phx.gen.auth

## [v0.1.0](http://10.0.0.11/inhji/mirage2.git/compare/v0.1.0...v0.1.0) (2021-11-28)




### Features:

* add git ops

### Bug Fixes:

* change database for test and dev to mirage2
