import crypto from "crypto";
import { PutObjectCommand } from "@aws-sdk/client-s3";
import redis, { ensureRedis } from "../config/redis.js";
import { s3 } from "../config/s3.js";
import Post from "../models/Post.js";

export const getPosts = async (req, res) => {
  try {
    console.log("👉 Request aayi");

    let isRedisAvailable = false;

    // 🔥 Redis check with safety (no hang)
    try {
      isRedisAvailable = await Promise.race([
        ensureRedis(),
        new Promise((resolve) => setTimeout(() => resolve(false), 1000)),
      ]);
    } catch {
      isRedisAvailable = false;
    }

    // ✅ Try cache
    if (isRedisAvailable && redis.isReady) {
      try {
        const cached = await redis.get("posts");
        if (cached) {
          console.log("⚡ Redis cache hit");
          return res.json(JSON.parse(cached));
        }
      } catch {
        console.log("Redis read failed");
      }
    }

    console.log("🐢 DB hit");

    const posts = await Post.findAll();

    // ✅ Save cache (optional)
    if (isRedisAvailable && redis.isReady) {
      try {
        await redis.setEx("posts", 60, JSON.stringify(posts));
      } catch {
        console.log("Redis write failed");
      }
    }

    // 🔥 ALWAYS SEND RESPONSE
    res.json(posts);

  } catch (err) {
    console.error("❌ ERROR:", err);
    res.status(500).json({ error: err.message });
  }
};

export const createPost = async (req, res) => {
  try {
    const { title, description } = req.body;

    if (!title || !description) {
      return res.status(400).json({ message: "Title and description are required" });
    }

    if (req.file?.buffer) {
      const bucket = process.env.BUCKET_NAME;
      if (!bucket) {
        return res.status(500).json({ message: "S3 bucket is not configured" });
      }

      const original = req.file.originalname || "upload";
      const ext = original.includes(".") ? `.${original.split(".").pop()}` : "";
      const key = `uploads/${Date.now()}-${crypto.randomUUID()}${ext}`;

      await s3.send(
        new PutObjectCommand({
          Bucket: bucket,
          Key: key,
          Body: req.file.buffer,
          ContentType: req.file.mimetype || "application/octet-stream",
        })
      );
    }

    const post = await Post.create({
      title,
      description,
      image: null,
    });

    if (redis?.isReady) {
      try {
        await redis.del("posts");
      } catch {
        console.log("Redis cache clear failed");
      }
    }

    return res.status(201).json(post);
  } catch (err) {
    console.error("❌ ERROR:", err);
    return res.status(500).json({ error: err.message });
  }
};