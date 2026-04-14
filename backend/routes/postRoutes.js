import express from "express";
import upload from "../middleware/upload.js";
import auth from "../middleware/authMiddleware.js";
import { createPost, getPosts } from "../controllers/postController.js";

const router = express.Router();

router.get("/", getPosts);
router.post("/", auth, upload.single("image"), createPost);

export default router;