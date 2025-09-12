# Node + TypeScript Setup Guide

## Installation

```bash
npm init -y
npm install typescript ts-node @types/node --save-dev
```

---

## Initialize TypeScript

```bash
npx tsc --init
```

This generates `tsconfig.json`.

---

## Example `tsconfig.json`

Keep it minimal for Node:

```json
{
    "compilerOptions": {
        "target": "ES2020",
        "module": "commonjs",
        "rootDir": "src",
        "outDir": "dist",
        "strict": true,
        "esModuleInterop": true,
        "skipLibCheck": true
    }
}
```

---

## Folder Structure

```
project/
├── src/
│   └── index.ts
├── dist/
├── package.json
└── tsconfig.json
```

---

## Run Project

-   Compile TypeScript:

```bash
npx tsc
```

-   Run directly with ts-node:

```bash
npx ts-node src/index.ts
```

-   Or add `scripts` in `package.json`:

```json
"scripts": {
  "dev": "ts-node src/index.ts",
  "build": "tsc",
  "start": "node dist/index.js"
}
```

## With Nodemon

-   Create a `nodemon.json` with below config

```json
{
    "watch": ["src"],
    "ext": "ts",
    "exec": "rm -rf dist && tsc && node dist/index.js"
}
```

-   Run nodemon

```bash
nodemon
```
