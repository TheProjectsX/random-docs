import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
    {
        name: { type: String, required: true },
        email: { type: String, unique: true, required: true },
        verified: { type: Boolean, default: false },
    },
    { timestamps: true } // adds createdAt + updatedAt
);

const User = mongoose.model("User", userSchema);

export default User;
