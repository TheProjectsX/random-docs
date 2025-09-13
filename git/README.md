# Git Workflow Guide

## 1️⃣ Initial Setup (First time for a repo)

```bash
# Set your identity
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# Initialize repo or clone existing
git init                       # Initialize a new local repo
git clone <remote-url>          # Clone an existing repo

# Add remote (if not cloned)
git remote add origin <remote-url>
git remote -v                   # Verify remote
```

---

## 2️⃣ Daily Workflow (Local changes → Commit → Push)

```bash
git status                      # Check modified files
git add .                        # Stage all changes (or git add <file>)
git commit -m "Your commit message"   # Commit changes
git pull origin main --rebase    # Update local branch before pushing (optional but safe)
git push origin main             # Push commits to remote
```

---

## 3️⃣ Branching Workflow (Feature development)

```bash
# Create & switch to a new feature branch
git checkout -b feature

# Work, stage, and commit
git add .
git commit -m "Add awesome feature"

# Push branch for remote / PR
git push -u origin feature

# Update your branch with latest main
git fetch
git pull --rebase origin main

# Merge feature back into main (after review / PR)
git checkout main
git merge feature

# Delete feature branch (optional)
git branch -d feature       # local
git push origin --delete feature   # remote
```

---

## 4️⃣ Undo / Fix Mistakes

```bash
git reset --soft HEAD~1         # Undo last commit, keep changes staged
git reset --hard HEAD~1         # Undo last commit, discard changes
git checkout -- <file>          # Discard file changes
git revert <commit-hash>        # Revert a specific commit (safe for team)
```

---

## 5️⃣ Stash (Save Work Temporarily)

```bash
git stash                        # Save uncommitted changes
git stash list                   # List stashed changes
git stash pop                    # Apply stashed changes back
```
