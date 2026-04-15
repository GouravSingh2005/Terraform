import dotenv from "dotenv";
dotenv.config({ path: ".env.prod" });

import express from "express";
import cors from "cors";

import sequelize from "./config/db.js";
import { ensureRedis } from "./config/redis.js";

import authRoutes from "./routes/authRoutes.js";
import postRoutes from "./routes/postRoutes.js";

const app = express();

// 🔥 crash debugging (VERY IMPORTANT)
process.on("uncaughtException", (err) => {
  console.error("UNCAUGHT EXCEPTION 💥", err);
});

process.on("unhandledRejection", (err) => {
  console.error("UNHANDLED REJECTION 💥", err);
});

// Prevent terminal job-control signals from stopping the server.
// This keeps the process running even if the terminal sends TSTP/HUP.
const ignoreSignal = (signal) => {
  process.on(signal, () => {
    console.warn(`Ignored ${signal} to keep server running`);
  });
};

["SIGTSTP", "SIGTTIN", "SIGTTOU", "SIGHUP"].forEach(ignoreSignal);

// Middlewares
app.use(cors());
app.use(express.json());

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/posts", postRoutes);

// Debug
console.log("DB_USER:", process.env.DB_USER);
console.log("DB_PASSWORD:", process.env.DB_PASSWORD);

// ✅ Proper startup flow
const startServer = async () => {
  try {
    await sequelize.authenticate();
    console.log("DB authenticated ✅");

    await sequelize.sync({ alter: true });
    console.log("DB synced ✅");

    const redisOk = await ensureRedis();
    console.log(redisOk ? "Redis connected ✅" : "Redis unavailable ⚠️");

    app.listen(5000, () => {
      console.log("Server running 🚀 on port 5000");
    });
  } catch (err) {
    console.error("Startup error ❌", err);
  }
};

startServer();