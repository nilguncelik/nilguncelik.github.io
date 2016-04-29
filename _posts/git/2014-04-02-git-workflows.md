---
title: Git Workflows
author: NC
category: git
public: true
---

## Branching Models

- <http://www.slideshare.net/lemiorhan/git-and-git-workflow-models-as-catalysts-of-software-development>

### Main Branches

- Permanent (long running) branches which are created at the very beginning and never deleted.
- These branches are at various levels of stability; when they reach a more stable level, they're merged into the branch above them.

- Development: reflects the latest delivered development changes for the next release. It’s used to pull in feature branches when they’re ready, to make sure they pass all the tests and don’t introduce bugs.
- Test & QA: reflects the code which is deployed to test/qa environment for testing.
- Staging & UAT: preprod. reflects the code which is deployed to staging/uat for testing.
- Production: reflect the code which is deployed to production.



### Supporting Branches

- They have limited life time and will ve removed eventually.
- They have specific purpose and strict rules for originating and target branches.
- e.g. feature, hotfix, release branches.


### Feature (Topic) Branches
- A feature branch is a short-lived branch that you create and use for a single particular feature.
- All features branches should be created from development branch.
- Take a feature branch regardless of the feature size.
- Only minor issues like typos can be fixed on development branch.

- This technique allows you to context-switch quickly and completely – because your work is separated into silos where all the changes in that branch have to do with that topic, it’s easier to see what has happened during code review and such. You can keep the changes there for minutes, days, or months, and merge them in when they’re ready, regardless of the order in which they were created or worked on.

- Feature development workflow:

```sh
#clone the remote repo
$ git checkout -b my_new_feature
#..work and commit some stuff ( WIP - work in progress)
$ git rebase development
#..work and commit some stuff
$ git rebase development
#..finish the feature

# one option:
$ git rebase -i origin/master
# squash your commits
$ git checkout development
$ git merge my_new_feature

# another option:
$ git checkout development
$ git merge --squash my_new_feature

# If you are making a bug fix, squash the commits down into
# one and exactly one commit that completely represents that bug fix.
# Half of a bug fix is useless!


$ git commit -m "added my_new_feature"
$ git branch -D my_new_feature
```
- <http://stackoverflow.com/questions/457927/git-workflow-and-rebase-vs-merge-questions>



### Release Branches
- Release branch is created from development branch when all features are ready for the next release.
- Only fixes are allowed on this branch (also called feature freeze).
- These fixes are continously merged back to development branch.
- After all fixes, this branch is merged into production branch and production branch is tagged.
- Then it is deleted.

### Hotfix Branches

- They are required because each fix should be well tested and verified. Therefore you may need to rollback what you have done in the fix.
- When a hotfix is required a new branch is created from production branch.
- Fix is developed, tested and verified in hotfix branch.
- Hot fix is merged back to development branch.
- Hot fix is merged with production branch and production branch is tagged.



![](/img/git_branching_model.png)



## Git Workflows


### Centralized Workflow

- Oldschool way of using VCSs.

### Integration-Manager Workflow

- Github open source project workflow.


### Dictator and Lieutenants Workflow

- It’s generally used by huge projects with hundreds of collaborators; one famous example is the Linux kernel.
- Various integration managers are in charge of certain parts of the repository; they’re called lieutenants. All the lieutenants have one integration manager known as the benevolent dictator.


**References**
- [Pro Git - Book](http://git-scm.com/book)
- [Git and Git Workflow Models as Catalysts of Software Development](http://www.slideshare.net/lemiorhan/git-and-git-workflow-models-as-catalysts-of-software-development)
- [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)
