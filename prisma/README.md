### Prisma Installation

```bash
npm install prisma @prisma/client sqlite3

# Initialize prisma
npx prisma init
```

### Setting up SQLite

Edit in `prisma/schema.prisma`

```prisma
datasource db {
  provider = "sqlite" // or "postgresql"
  url      = "file:./dev.db" // or env("DATABASE_URL")
}
```

### Add Model

Edit in `prisma/schema.prisma`

```prisma
model UserTask {
  id          String   @id @default(uuid()) // or cuid() / autoincrement()
  title       String
  description String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}
```

### Generate Prisma Client

```bash
npx prisma generate
```

### Migrate after Updating Model

```bash
npx prisma migrate dev --name init # change the name from `init` to the desired
```

### View the Database as GUI

```bash
npx prisma studio
```

## NOTE:

-   If in `prisma/schema.prisma`, `{ output: "..." }` is provided in `generate client`, then, while importing `PrismaClient`, we need to import it from the `output` folder. EX:
    - `import { PrismaClient } from "./generated/prisma/index.js"`
