import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import API from "@/api/axios";

export default function Login() {
  const navigate = useNavigate();

  const [form, setForm] = useState({
    email: "",
    password: "",
  });

  const handleLogin = async () => {
    try {
      const res = await API.post("/auth/login", form);

      localStorage.setItem("token", res.data.token);

      navigate("/");
    } catch {
      alert("Invalid credentials ❌");
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-[#0f172a]">
      <motion.div
        initial={{ opacity: 0, y: 40 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-[#1e293b] p-8 rounded-2xl w-full max-w-md shadow-xl"
      >
        <h2 className="text-3xl text-white text-center mb-6 font-bold">
          Login 🔐
        </h2>

        <div className="flex flex-col gap-4">
          <input
            placeholder="Email"
            className="p-3 rounded bg-gray-800 text-white"
            onChange={(e) =>
              setForm({ ...form, email: e.target.value })
            }
          />

          <input
            type="password"
            placeholder="Password"
            className="p-3 rounded bg-gray-800 text-white"
            onChange={(e) =>
              setForm({ ...form, password: e.target.value })
            }
          />

          <button
            onClick={handleLogin}
            className="bg-purple-600 py-3 rounded text-white hover:bg-purple-700"
          >
            Login
          </button>

          <button
            onClick={() => navigate("/register")}
            className="border border-gray-600 py-3 rounded text-white hover:bg-gray-800"
          >
            Create a new account
          </button>
        </div>
      </motion.div>
    </div>
  );
}