import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";

export default function Hero() {
  return (
    <div className="relative flex flex-col items-center justify-center text-center py-24 px-4 overflow-hidden">
      
      {/* 🔥 Background Gradient */}
      <div className="absolute inset-0 bg-gradient-to-br from-purple-600/20 via-blue-500/20 to-pink-500/20 blur-3xl opacity-50"></div>

      {/* 🔥 Heading */}
      <motion.h1
        initial={{ opacity: 0, y: 60 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
        className="text-4xl md:text-6xl font-extrabold bg-gradient-to-r from-purple-400 via-blue-400 to-pink-400 text-transparent bg-clip-text"
      >
        Share Your Ideas 💡
      </motion.h1>

      {/* 🔥 Subtitle */}
      <motion.p
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3 }}
        className="text-gray-400 mt-6 max-w-xl text-lg"
      >
        Write blogs, upload images, and inspire the world with your creativity.
      </motion.p>

      {/* 🔥 Buttons */}
      <motion.div
        initial={{ opacity: 0, scale: 0.8 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ delay: 0.5 }}
        className="mt-8 flex gap-4"
      >
        <Button size="lg" className="bg-purple-600 hover:bg-purple-700">
          Start Writing ✍️
        </Button>

        <Button
          size="lg"
          variant="outline"
          className="border-gray-500 text-white hover:bg-gray-800"
        >
          Explore Blogs 🚀
        </Button>
      </motion.div>
    </div>
  );
}