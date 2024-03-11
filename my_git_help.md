

# Commonly used Git commands:

* **git status** shows the status of changes as untracked, modified, or staged.

* **git add** stages a change. Git tracks changes to a developer's codebase, but it's necessary to stage and take a snapshot of the changes to include them in the project's history. This command performs staging, the first part of that two-step process. Any changes that are staged will become a part of the next snapshot and a part of the project's history. Staging and committing separately gives developers complete control over the history of their project without changing how they code and work.

* **git commit** saves the snapshot to the project history and completes the change-tracking process. In short, a commit functions like taking a photo. Anything staged with git add will become part of the snapshot with git commit.

For me, a common sequence of commands is:
```python
git add FILENAME
git commit -m "The commit message"
git push
```

## References 

https://docs.github.com/en/get-started/using-git/about-git

https://git-scm.com/docs


> Written with [StackEdit](https://stackedit.io/).
