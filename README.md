# Mobile programming final exam

## Clone this project
If this is your first time, clone this project
`git clone git@github.com:thanhNgan13/Threads-Clone.git`


## Starting development by branching out

*First rule: DO NOT PUSH DIRECTLY TO THE `master` BRANCH*

You should always create a new branch when working on new features, fixing bugs, or else

Usually from the master branch, you checkout and create a new branch so you can get the latest changes from the `master`
```
git checkout master
git checkout -b features-login-form`
```

### Branch's name/Tên của branch
You should name your branch easy to understand. The branch name should describe shortly what you will work on.
For example, new features, new pages, new things, etc... should be
`features-login-form`, `features-sign-up-pages`, `features-blog-posting`
For bugfixes, refactoring, it should be something like
`fix-login-form-ui`, `fix-signup-pages-layout`, `fix-bug-in-login-form`

## Commit and pushing

You must understand local repo and remote repo meaning in Git.
In your local repo: edit files, add files to staging, commit files. After feeling satisfied with your work on local, push to remote using
```
git push origin your-branch-name
```
or using GUI

## Creating Github pull request

Pull request is to merge your changes in your branch into the master branch.
How pull request works and how to create a pull request in Github, please read this.

https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request

After create pull request, add Reviewer using the menu on the left sidebar.
https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/requesting-a-pull-request-review


## Merge pull request
https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/merging-a-pull-request

The review is done. You can merge the pull request. This time we use the merge approach.
Simply click the `Merge pull request button` or `Create a merge commit` when clicking the dropdown beside the `Merge pull request` button.
