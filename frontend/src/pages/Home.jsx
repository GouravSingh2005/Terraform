import { useEffect, useState } from "react";

import Navbar from "@/components/Navbar";
import Hero from "@/components/Hero";
import PostCard from "@/components/PostCard";
import API from "@/api/axios";

export default function Home() {
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(true);

  // 🔥 Backend call
  useEffect(() => {
    API.get("/posts")
      .then((res) => {
        setPosts(res.data);
      })
      .catch((err) => {
        console.log(err);
        alert("Failed to fetch posts ❌");
      })
      .finally(() => {
        setLoading(false);
      });
  }, []);

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <Hero />

      {/* 🔥 Loading */}
      {loading ? (
        <p className="text-center mt-10 text-gray-400">
          Loading posts...
        </p>
      ) : (
        <div className="grid gap-6 px-6 md:grid-cols-2 lg:grid-cols-3 pb-10">
          
          {/* 🔥 No posts */}
          {posts.length === 0 ? (
            <p className="text-center col-span-full text-gray-400">
              No posts found 😢
            </p>
          ) : (
            posts.map((post, i) => (
              <PostCard key={i} post={post} />
            ))
          )}
        </div>
      )}
    </div>
  );
}