### Install

```bash
npm install mongodb
```

---

### Connect

```ts
import { MongoClient } from "mongodb";

const client = new MongoClient("mongodb://localhost:27017");
await client.connect();

const db = client.db("testdb");
const users = db.collection("users");
```

---

### CRUD

**Insert**

```ts
await users.insertOne({ name: "Alice", email: "alice@test.com" });
```

**Find**

```ts
const all = await users.find().toArray();
const one = await users.findOne({ email: "alice@test.com" });
```

**Update**

```ts
await users.updateOne(
    { email: "alice@test.com" },
    { $set: { name: "Alicia" } }
);
```

**Delete**

```ts
await users.deleteOne({ email: "alice@test.com" });
```
