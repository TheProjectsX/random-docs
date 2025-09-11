import { PrismaClient } from "../../generated/prisma/index.js";

// Let's assume that our `output` path was "../generated/prisma"

const globalForPrisma = {};

const prisma = globalForPrisma.prisma || new PrismaClient();
if (process.env.NODE_ENV !== "production") globalForPrisma.prisma = prisma;

export default prisma;
