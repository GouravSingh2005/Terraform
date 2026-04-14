import dotenv from "dotenv";
import { createClient } from "redis";

dotenv.config({ path: ".env.local" });

const redisHost = process.env.REDIS_HOST || "127.0.0.1";
const redisPort = Number(process.env.REDIS_PORT || 6379);

const redisClient = createClient({
  socket: {
    host: redisHost,
    port: redisPort,
  },
});

redisClient.on("error", (err) => {
  console.error("Redis error:", err?.message || err);
});

let redisDisabled = false;
let redisConnecting = false;

export const ensureRedis = async () => {
  if (redisDisabled) return false;
  if (redisClient.isReady) return true;
  if (redisConnecting) return false;

  redisConnecting = true;

  try {
    await Promise.race([
      redisClient.connect(),
      new Promise((_, reject) =>
        setTimeout(() => reject(new Error("Redis timeout")), 2000)
      ),
    ]);

    return true;
  } catch (err) {
    redisDisabled = true;
    console.error("Redis disabled ❌:", err.message);
    return false;
  } finally {
    redisConnecting = false;
  }
};

export default redisClient;