# Expose MongoDB on a VPS for Remote Access

By default, MongoDB only accepts connections from `localhost`. Follow the steps below to allow remote connections securely.

---

## 1. Allow Remote Connections

Open the MongoDB configuration file:

```bash
sudo nano /etc/mongod.conf
```

Find the `net` section:

```yaml
net:
    port: 27017
    bindIp: 127.0.0.1
```

Replace it with:

```yaml
net:
    port: 27017
    bindIp: 0.0.0.0
```

This allows MongoDB to accept connections from any IP address.

If you only want to allow specific IP addresses, specify them instead:

```yaml
net:
    port: 27017
    bindIp: 127.0.0.1,100.200.300.400
```

---

## 2. Enable Authentication

Open the same configuration file:

```bash
sudo nano /etc/mongod.conf
```

Ensure the following section exists:

```yaml
security:
    authorization: enabled
```

If `authorization` is missing or disabled, set it to `enabled`.

---

## 3. Create a Database User

Connect to MongoDB:

```bash
mongosh
```

### Create an Administrator

Switch to the `admin` database:

```javascript
use admin
```

Create an admin user:

```javascript
db.createUser({
    user: "admin",
    pwd: "StrongPassword123",
    roles: [{ role: "root", db: "admin" }],
});
```

Connection string:

```text
mongodb://admin:StrongPassword123@100.200.300.400:27017/?authSource=admin
```

---

### Create a User with Limited Permissions

Switch to the database where the user should be created:

```javascript
use local
```

Create the user:

```javascript
db.createUser({
    user: "user",
    pwd: "AnotherStrongPassword",
    roles: [{ role: "readWrite", db: "local" }],
});
```

Connection string:

```text
mongodb://user:AnotherStrongPassword@100.200.300.400:27017/?authSource=local
```

---

## 4. Open the MongoDB Port

If you're using UFW, allow incoming connections on port `27017`:

```bash
sudo ufw allow 27017
sudo ufw reload
```

---

## 5. Restart MongoDB

Apply all configuration changes by restarting the MongoDB service:

```bash
sudo systemctl restart mongod
```

You can verify that MongoDB is running:

```bash
sudo systemctl status mongod
```

---

## Replica Set Connection

If your MongoDB server is running as a replica set and you are connecting directly to a single node, add `directConnection=true` to the connection string.

Example:

```text
mongodb://admin:StrongPassword123@100.200.300.400:27017/?directConnection=true&authSource=admin
```
