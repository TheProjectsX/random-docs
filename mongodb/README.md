# MongoDB Setup

## Installation (Local)

1. Install [MongoDB Community Server](https://www.mongodb.com/try/download/community).
2. Start the MongoDB server:

```bash
mongod
```

3. Install MongoDB Node.js driver:

```bash
npm install mongodb
```

## Environment Variables

Create a `.env` file:

```env
MONGO_URI=mongodb://localhost:27017/myapp # myapp is the db name
```

## Atlas (Cloud)

-   You can also use [MongoDB Atlas](https://www.mongodb.com/atlas/database) instead of local.
-   Atlas provides a free tier cluster you can connect to using a URI like:

```
mongodb+srv://<username>:<password>@cluster0.mongodb.net/myapp # myapp is the db name
```

## Project Structure

```
project/
│── index.js        # Entry point
│── .env
│── package.json
```

## Run Project

```bash
node index.js
```

## Notes

-   Default local port: `27017`
-   GUI tool: [MongoDB Compass](https://www.mongodb.com/products/compass)
-   Use the official driver:

    ```js
    const { MongoClient } = require("mongodb");
    ```
