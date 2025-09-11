### Mongoose Installation

```bash
npm install mongoose
```

### Connect to MongoDB

Default local connection string:

```
mongodb://localhost:27017/mydb
```

Replace `mydb` with your database name.

### Define Schema & Model

-   Use `mongoose.Schema` to define fields and types.
-   Use `mongoose.model` to create a model from the schema.
-   Enable `{ timestamps: true }` in schema options to auto-manage `createdAt` and `updatedAt`.

### Import & Use Model

-   Import the model in your `index.js` (or routes).
-   Use it for CRUD operations (`create`, `find`, `findById`, `update`, `delete`).

### NOTE

-   MongoDB always provides an `_id` field by default.
-   `unique: true` is not a validator, it creates an index.
-   Add indexes manually if needed using `User.createIndexes()`.
