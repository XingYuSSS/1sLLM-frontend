# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0]

### Added

- Add streaming generate in `api` 
- Add streaming generate in `message controller`
- Add simple streaming generate animation in `message card` and `select card`
- Add `sending` field in `Message` class
- Add `useStream` field in `local`
- Add `useStream` option in `setting` page
- Add fallback locale
- Add loading animation of register and update

### Changed 

- Move all init statement in `main` to `init` file
- Move the order of fields in `local`
- Move operates other than `GetStorage` out of `local`
- Set useless `obs` variable to `var` in `setting controller`
- Update `README`
- Password will hide in `login`
- change "sign up" to "register"

### Fixed 

- Fix the `locale` and `thememode` field back to default after restart
- Fix backing to homepage is available while updating apikey

### Removed

- remove useless widget

## [0.1.0] - 2024-07-22

### Added

- Add all files of this project
- Add README and CHANGELOG
- Add LICENSE

[unreleased]: https://github.com/XingYuSSS/1sLLM-frontend/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/XingYuSSS/1sLLM-frontend/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/XingYuSSS/1sLLM-frontend/tree/v0.1.0
