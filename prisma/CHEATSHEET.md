## ✅ Common Responses

-   **`findUnique / findFirst`**

    -   If found → returns the user object
    -   If not found → returns `null`

-   **`findMany`**

    -   Always returns an array
    -   If no match → returns `[]` (empty array)

-   **`create / update / delete / upsert`**

    -   If success → returns the created/updated/deleted record
    -   If record not found (in update/delete) → throws an error

---

## ⚠️ Common Prisma Errors

-   `P2002` → Unique constraint failed (e.g., duplicate email)
-   `P2003` → Foreign key constraint failed (related record missing)
-   `P2025` → Record not found (update/delete on a non-existing record)
-   `P2014` → Relation violation (trying to connect/disconnect invalid relations)
-   `P2000` → Value too long for column type

---

## 🔎 Query Options (Filtering, Pagination, Sorting)

-   **Filtering**

    ```js
    prisma.user.findMany({
        where: {
            verified: true,
            name: { contains: "John" }, // partial match
            email: { endsWith: "@gmail.com" }, // suffix match
        },
    });
    ```

-   **Pagination**

    ```js
    prisma.user.findMany({
        skip: 10, // offset (start after 10 records)
        take: 5, // limit (fetch next 5 records)
    });
    ```

-   **Sorting**

    ```js
    prisma.user.findMany({
        orderBy: { createdAt: "desc" }, // or "asc"
    });
    ```

-   **Select specific fields**

    ```js
    prisma.user.findMany({
        select: { id: true, name: true }, // only return these fields
    });
    ```

-   **Include relations**

    ```js
    prisma.user.findMany({
        include: { posts: true }, // if user → posts relation exists
    });
    ```

---

## ⚡ Example Patterns

-   **Get first 10 verified users ordered by newest**

    ```js
    prisma.user.findMany({
        where: { verified: true },
        orderBy: { createdAt: "desc" },
        take: 10,
    });
    ```

-   **Find user by email (case-insensitive)**

    ```js
    prisma.user.findUnique({
        where: { email: "test@example.com" },
    });
    // or with filter
    prisma.user.findFirst({
        where: { email: { equals: "test@example.com", mode: "insensitive" } },
    });
    ```

-   **Count all verified users**

    ```js
    prisma.user.count({
        where: { verified: true },
    });
    ```
