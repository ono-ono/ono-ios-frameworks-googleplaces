# ono-ios-frameworks-googleplaces
Google Places wrapper used as a framework for Ono Technologies iOS application

## Versioning

The key with modularized approach is to keep track for each release what version of the framework(s) is paired with which app version. The best way to do this is to `git tag` code changes.

### Guidelines

Versioning follows [semantic versioning guidelines](https://semver.org) as much as possible. Version consists of 3 parts, followed by build number:

```
Major.Minor.Patch (Build)
== 1.4.0 (231)
== 2.0 (302)
```

General rules:

- *Version* = marketing domain
- *Build* = technical domain
- Build number must always be updated, for each release. Updating build count is independent from the version update.

Versioning guidelines:

- If you are adding new functionality without changing any existing behavior, then increment only PATCH part.
- If you are making changes that influence existing code / behavior but should not break rest of the app using that code, then increment MINOR part of the version and *reset* PATCH to `0`.
- If you making large architectural changes that require re-factoring rest of the app, then update MAJOR part of the version and reset MINOR and PATCH to `0`.

### Where to update build & version

Version is a string, set on the project level, in the `MARKETING_VERSION` field in *Build Settings*.

Build is Integer number, set on `CURRENT_PROJECT_VERSION` in *Build Settings* at the Project Level.

Each target will inherit these values from the project. Thus make sure that no target overrides this setting unless there is a good reason for that.

This way, you only need to:

- update one singular setting on the project
- make git tag with that same change

Then **make sure** to note in a comment – for each task you complete in JIRA – what version/builds are implementing the changes related to that task.
