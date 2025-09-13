# 🚀 Git Cheatsheet

## 🔹 Setup

```bash
git init                     # Initialize repo
git clone <url>              # Clone repo
git remote -v                # List remotes
git remote add origin <url>  # Add remote
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

---

## 🔹 Daily Workflow

```bash
git status                   # Show changes
git add .                    # Stage all changes
git commit -m "message"      # Commit
git push origin main         # Push changes
git pull origin main         # Pull latest changes
```

---

## 🔹 Branching (Teamwork)

```bash
git branch                   # List branches
git branch feature-x         # Create new branch
git checkout feature-x       # Switch to branch
git checkout -b feature-x    # Create + switch branch
git merge feature-x          # Merge into current branch
git branch -d feature-x      # Delete branch (local)
git push origin --delete feature-x   # Delete branch (remote)
```

---

## 🔹 Collaboration

```bash
git fetch                    # Get latest refs from remote
git pull --rebase origin main # Update your branch with latest main
git push origin feature-x     # Push branch for PR
git stash                     # Save uncommitted changes
git stash pop                 # Apply stashed changes
```

---

## 🔹 Undo / Fix

```bash
git reset --soft HEAD~1       # Undo last commit, keep changes
git reset --hard HEAD~1       # Undo last commit, discard changes
git checkout -- <file>        # Discard file changes
git revert <commit>           # Revert specific commit (safe for team)
git log --oneline --graph     # Pretty log
```

---

## 🔹 Tags (Releases)

```bash
git tag v1.0.0                # Create tag
git push origin v1.0.0        # Push tag
git tag -d v1.0.0             # Delete tag (local)
git push origin :refs/tags/v1.0.0   # Delete tag (remote)
```
