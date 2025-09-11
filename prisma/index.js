import express from "express";
import prisma from "./prismaClient/prisma/index.js";

const app = express();
app.use(express.json());

/**
 * Create User
 * prisma.user.create
 */
app.post("/users", async (req, res) => {
    try {
        const response = await prisma.user.create({
            data: {
                name: req.body.name,
                email: req.body.email,
                verified: false,
            },
        });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Create Many Users
 * prisma.user.createMany
 */
app.post("/users/many", async (req, res) => {
    try {
        const response = await prisma.user.createMany({
            data: req.body.users, // [{name, email}, ...]
        });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Find All Users
 * prisma.user.findMany
 */
app.get("/users", async (req, res) => {
    try {
        const response = await prisma.user.findMany({});
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Find Unique User
 * prisma.user.findUnique
 */
app.get("/users/:id", async (req, res) => {
    try {
        const response = await prisma.user.findUnique({
            where: { id: req.params.id },
        });
        res.json(response ?? "No User Found");
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Find First User by Email
 * prisma.user.findFirst
 */
app.get("/users/email/:email", async (req, res) => {
    try {
        const response = await prisma.user.findFirst({
            where: { email: req.params.email },
        });
        res.json(response ?? "No User Found");
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Count Users
 * prisma.user.count
 */
app.get("/users-count", async (req, res) => {
    try {
        const response = await prisma.user.count();
        res.json({ count: response });
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Update User
 * prisma.user.update
 */
app.put("/users/:id", async (req, res) => {
    try {
        const response = await prisma.user.update({
            where: { id: req.params.id },
            data: { verified: req.body.verified },
        });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Update Many Users
 * prisma.user.updateMany
 */
app.put("/users", async (req, res) => {
    try {
        const response = await prisma.user.updateMany({
            data: { verified: true },
        });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Upsert User
 * prisma.user.upsert
 */
app.post("/users/upsert", async (req, res) => {
    try {
        const response = await prisma.user.upsert({
            where: { email: req.body.email },
            update: { name: req.body.name },
            create: { name: req.body.name, email: req.body.email },
        });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Delete User
 * prisma.user.delete
 */
app.delete("/users/:id", async (req, res) => {
    try {
        const response = await prisma.user.delete({
            where: { id: req.params.id },
        });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Delete Many Users
 * prisma.user.deleteMany
 */
app.delete("/users", async (req, res) => {
    try {
        const response = await prisma.user.deleteMany({
            where: { verified: false },
        });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Aggregate Users
 * prisma.user.aggregate
 */
app.get("/users-aggregate", async (req, res) => {
    try {
        const response = await prisma.user.aggregate({
            _count: { verified: true },
            _min: { createdAt: true },
            _max: { createdAt: true },
        });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Group By Users
 * prisma.user.groupBy
 */
app.get("/users-group", async (req, res) => {
    try {
        const response = await prisma.user.groupBy({
            by: ["verified"],
            _count: { verified: true },
        });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

app.listen(5000, () => {
    console.log("Running at http://localhost:5000");
});
