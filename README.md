> ℹ️ Issues for this repository are tracked on [Phabricator](https://phabricator.wikimedia.org/project/board/5563/) - ([Click here to open a new one](https://phabricator.wikimedia.org/maniphest/task/edit/form/1/?tags=wikibase_cloud
))

Using addwiki:
https://github.com/addwiki/mediawiki-api

Copy public_html/config.json.template to config.json and modify for your needs

## Syncing this fork
- Switch/Create a branch for the merge
- Add local upstream remote: `git remote add upstream https://github.com/magnusmanske/quickstatements`
- Fetch upstream: `git fetch upstream`  
- Merge master(!) branch: `git merge upstream/master`
- Resolve conflicts (if any)
- Update Changelog

