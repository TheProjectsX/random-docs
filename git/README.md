# Git Workflow Guide

## 📚 Table of Contents

1. [Authentication & Authorization](#authentication--authorization)
    - [Windows](#windows)
    - [Linux](#linux)
    - [Git Identity Setup](#git-identity-setup)

2. [Initial Setup (First time for a repo)](#1️⃣-initial-setup-first-time-for-a-repo)
3. [Daily Workflow (Local → Commit → Push)](#2️⃣-daily-workflow-local-changes--commit--push)
4. [Branching Workflow (Feature development)](#3️⃣-branching-workflow-feature-development)
5. [Undo / Fix Mistakes](#4️⃣-undo--fix-mistakes)
6. [Stash (Save Work Temporarily)](#5️⃣-stash-save-work-temporarily)

---

## Authentication & Authorization

To use Git with GitHub (or similar platforms), you must authenticate your machine with the platform.

### Windows

- Install **Git Bash** from the official site:
  [https://git-scm.com/install/windows](https://git-scm.com/install/windows)
- When you try to `git push` or `git pull`:
    - A browser-based login popup will appear
    - Log in with your GitHub account

- Authentication is handled automatically after that

---

### Linux

#### 1. Install Git Credential Manager (GCM)

- Download GCM from the releases page:
  [https://github.com/git-ecosystem/git-credential-manager/releases](https://github.com/git-ecosystem/git-credential-manager/releases)
- Download the `.deb` file
- Install it:

```bash
sudo dpkg -i gcm-linux_amd64.<version>.deb
```

---

#### 2. Generate a GPG Key

(The generated long encrypted string is your `<gpg-id>`)

```bash
gpg --gen-key
```

You’ll be asked for:

- Name
- Email

---

#### 3. Setup `pass` (Credential Storage)

```bash
sudo apt install pass
pass init <gpg-id>
```

---

#### 4. Authenticate with GitHub

- On `git push` or `git pull`:
    - A browser login popup will appear **or**
    - You’ll be asked to match the GPG key

- Complete the login — authentication is done

---

### Git Identity Setup

Set your global Git identity (required for commits):

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

---

## 1️⃣ Initial Setup (First time for a repo)

```bash
# Initialize repo or clone existing
git init                        # Initialize a new local repo
git clone <remote-url>          # Clone an existing repo

# Add remote (if not cloned)
git remote add origin <remote-url>
git remote -v                   # Verify remote
```

---

## 2️⃣ Daily Workflow (Local changes → Commit → Push)

```bash
git status                      # Check modified files
git add .                       # Stage all changes (or git add <file>)
git commit -m "Your commit message"
git pull origin main --rebase    # Update local branch (optional but safe)
git push origin main
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

# Merge feature back into main
git checkout main
git merge feature

# Delete feature branch (optional)
git branch -d feature                # local
git push origin --delete feature     # remote
```

---

## 4️⃣ Undo / Fix Mistakes

```bash
git reset --soft HEAD~1         # Undo last commit, keep changes staged
git reset --hard HEAD~1         # Undo last commit, discard changes
git checkout -- <file>          # Discard file changes
git revert <commit-hash>        # Revert a commit (safe for teams)
```

---

## 5️⃣ Stash (Save Work Temporarily)

```bash
git stash
git stash list
git stash pop
```
