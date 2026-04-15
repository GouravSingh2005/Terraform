import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { motion } from "framer-motion";

export default function PostCard({ post }) {
  const [imageFailed, setImageFailed] = useState(false);
  const imageSource = post.imageUrl || post.image || "https://picsum.photos/400";

  return (
    <motion.div
      whileHover={{ scale: 1.05 }}
      transition={{ type: "spring", stiffness: 200 }}
    >
      <Card className="rounded-2xl overflow-hidden shadow-lg cursor-pointer bg-[#1e293b] border border-gray-700 hover:shadow-purple-500/20 transition">
        
        {/* IMAGE */}
        <img
          src={imageFailed ? "https://picsum.photos/400" : imageSource}
          className="h-52 w-full object-cover"
          alt="post"
          onError={() => setImageFailed(true)}
        />

        <CardContent className="p-4">
          
          {/* TITLE */}
          <h2 className="text-lg font-semibold text-white">
            {post.title}
          </h2>

          {/* DESCRIPTION */}
          <p className="text-sm text-gray-400 mt-1 line-clamp-2">
            {post.description}
          </p>

          {/* AUTHOR */}
          <div className="flex items-center mt-4 gap-2">
            <Avatar>
              <AvatarFallback>
                {post.author?.[0] || "U"}
              </AvatarFallback>
            </Avatar>

            <span className="text-sm text-gray-300">
              {post.author || "Unknown"}
            </span>
          </div>
        </CardContent>
      </Card>
    </motion.div>
  );
}