> ℹ️ Issues for this repository are tracked on [Phabricator](https://phabricator.wikimedia.org/project/board/5563/) - ([Click here to open a new one](https://phabricator.wikimedia.org/maniphest/task/edit/form/1/?tags=wikibase_cloud
))

This repo is a fork of https://github.com/magnusmanske/quickstatements

The Dockerfile build process runs composer and pulls a version the wbstack fork of magnus-tools from https://github.com/wbstack/magnustools/
This is then copied out of `/vendor` by a `composer` post-update/install hook and then finally copied into the correct place in the final image.

To update this repository you need to pull the updates from the upstream and ensure our customisations are working on them. This may be easiest to do with a `git pull --rebase` from upstream. You may also need to update our magnustools fork for compatibility and then use that updated version.

If you go through this process please also update here to document it

# Changelog

Using addwiki:
https://github.com/addwiki/mediawiki-api

Copy public_html/config.json.template to config.json and modify for your needs
