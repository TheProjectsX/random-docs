# NestJS Setup

## Installation

```bash
npm install -g @nestjs/cli
nest new project-name
```

## Project Structure

```
project-name/
├── src/
│   ├── app.controller.ts       # Handles incoming requests
│   ├── app.service.ts          # Business logic
│   ├── app.module.ts           # Root module
│   ├── main.ts                 # Entry point
│   └── modules/                # Feature modules
│       └── example/
│           ├── example.module.ts
│           ├── example.controller.ts
│           └── example.service.ts
├── test/                       # Test files
├── package.json
├── tsconfig.json
└── nest-cli.json
```

## Running the App

```bash
npm run start         # development
npm run start:dev     # watch mode
npm run start:prod    # production
```

## NOTE:

-   Avoid putting too much logic inside **controllers** → move to services.
-   Don’t make **one huge module** → split features into smaller modules.
-   Avoid **circular dependencies** between modules.
-   Don’t skip using **DTOs and validation pipes** → keeps input clean and safe.
-   Avoid directly accessing environment variables in multiple places → use a config service.
