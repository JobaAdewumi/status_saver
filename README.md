# All Status Saver

An Android app that downloads statuses from major social media platforms

## Author

[Joba Adewumi](https://github.com/JobaAdewumi)

## Contribution Rules

### Contribution

**DO NOT PUSH DIRECTLY TO THE MAIN BRANCH**
To contribute you need to work in a branch that relates with what you are trying to fix or create a new branch that would be merged from the pull request.

```bash
# When you want to start working check all the branches available, if there is a branch that pertains to what you want to do.

git switch branch-name

# But to be on the safe side just create your own branch when you want to work on something new

git checkout -b branch name
git push -u origin branch-name

# The above commands are to create a branch, switch to it and push it to github

# If you are on your branch or any other branch that was created by someone else before you work, git pull

git pull

# If you are done with your work follow the following steps

git commit -m 'summary of what you did in the commit'
git push

# From here you need to go to github and create a pull request to an upstream branch, frontend for frontend work and backend for backend work

# When it is approved it would be merged into the branch.

# DO NOT COMMIT OR PUSH TO MAIN BRANCH
# Bless you!

```

## Prerequisites

The project has dependencies that require Flutter 3.10.6 or higher, together
with Dart 3.0.6 or higher.

## Running Locally

1. First clone the repository:

```bash
git clone https://github.com/JobaAdewumi/status_saver.git
```

2. Install dependencies using pub:

```bash
pub get
```

1. Start the development with emulator or physical device connected:

```bash
flutter run
```
