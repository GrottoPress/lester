# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased] -

### Fixed
- Replace `require "http"` with `require "http/client"`

## [1.0.1] - 2024-08-15

### Fixed
- Add missing `require "http"`
- Add missing `require "http/web_socket"`
- Fix invalid websocket challenge verification

## [1.0.0] - 2023-05-29

### Added
- First stable release

## [0.4.0] - 2023-05-02

### Removed
- Remove `GrottoPress/hapi` shard

## [0.3.0] - 2023-04-04

### Changed
- Bump minimum required *Crystal* version to 1.2
- Upgrade GitHub actions

### Fixed
- Fix "Not Found" error when connecting to local LXD socket

## [0.2.2] - 2022-06-28

### Fixed
- Create new endpoint URIs instead of shallow copying existing ones

## [0.2.1] - 2022-03-17

### Changed
- Read HTTP responses from `body` instead of `body_io` in endpoint methods

## [0.2.0] - 2022-02-17

### Added
- Ensure support for *Crystal* v1.3

### Fixed
- Set content type to *octet-stream* for create instance file endpoint
- Add missing `Lester::Operation::Metadata#output` attribute
- Add missing `Lester::Operation::Metadata#return` attribute
- Add missing `Lester::Operation::Metadata#control` attribute
- Add missing `Lester::Operation::Metadata#fs` attribute

### Changed
- Change `Lester::Operation::Metadata#fds` return hash key type to `Int32`

## [0.1.0] - 2021-11-16

### Added
- Add server endpoints
- Add certificates endpoints
- Add cluster endpoints
- Add images endpoints
- Add instances endpoints
- Add metrics endpoint
- Add network ACLs endpoints
- Add networks endpoints
- Add network forwards endpoints
- Add network peers endpoints
- Add operations endpoints
- Add profiles endpoints
- Add projects endpoints
- Add storage endpoints
- Add warnings endpoints
