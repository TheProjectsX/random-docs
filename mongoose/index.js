import express from "express";
import mongoose from "mongoose";
import User from "./models/User.js";

const app = express();
app.use(express.json());

// Configuring Database (maybe use a diff file to export this func)
const connectDB = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI || "");
        console.log("MongoDB connected");
    } catch (error) {
        console.error("MongoDB connection error:", error);
        process.exit(1);
    }
};

/**
 * Create User
 * User.create
 */
app.post("/users", async (req, res) => {
    const { body } = req;
    try {
        const response = await User.create({
            name: body.name,
            email: body.email,
            verified: false,
        });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Create Many Users
 * User.insertMany
 */
app.post("/users/many", async (req, res) => {
    const { body } = req;
    try {
        const response = await User.insertMany(body.users); // [{name, email}, ...]
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Find All Users
 * User.find
 */
app.get("/users", async (req, res) => {
    try {
        const response = await User.find();
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Find Unique User by ID
 * User.findById
 */
app.get("/users/:id", async (req, res) => {
    const { params } = req;
    try {
        const response = await User.findById(params.id);
        res.json(response ?? "No User Found");
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Find First User by Email
 * User.findOne
 */
app.get("/users/email/:email", async (req, res) => {
    const { params } = req;
    try {
        const response = await User.findOne({ email: params.email });
        res.json(response ?? "No User Found");
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Count Users
 * User.countDocuments
 */
app.get("/users-count", async (req, res) => {
    try {
        const response = await User.countDocuments();
        res.json({ count: response });
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Update User
 * User.findByIdAndUpdate
 */
app.put("/users/:id", async (req, res) => {
    const { body, params } = req;
    try {
        const response = await User.findByIdAndUpdate(params.id, body, {
            new: true,
        });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Update Many Users
 * User.updateMany
 */
app.put("/users", async (req, res) => {
    try {
        const response = await User.updateMany({}, { verified: true });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Upsert User
 * User.findOneAndUpdate (with upsert: true)
 */
app.post("/users/upsert", async (req, res) => {
    const { body } = req;
    try {
        const response = await User.findOneAndUpdate(
            { email: body.email },
            { name: body.name },
            { upsert: true, new: true }
        );
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Delete User
 * User.findByIdAndDelete
 */
app.delete("/users/:id", async (req, res) => {
    const { params } = req;
    try {
        const response = await User.findByIdAndDelete(params.id);
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Delete Many Users
 * User.deleteMany
 */
app.delete("/users", async (req, res) => {
    try {
        const response = await User.deleteMany({ verified: false });
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

/**
 * Aggregate Users
 * User.aggregate
 */
app.get("/users-aggregate", async (req, res) => {
    try {
        const response = await User.aggregate([
            { $group: { _id: "$verified", count: { $sum: 1 } } },
        ]);
        res.json(response);
    } catch (error) {
        console.error(error);
        res.send("Error");
    }
});

// Connect Database and Start App
console.log("Starting...");
connectDB().then(() => {
    app.listen(process.env.PORT || 5000, () => {
        console.log(
            `Server running on http://localhost:${process.env.PORT || 5000}`
        );
    });
});
