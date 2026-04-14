import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import API from "@/api/axios";

export default function Register() {
  const navigate = useNavigate();

  const [form, setForm] = useState({
    email: "",
    password: "",
  });

  const handleRegister = async () => {
    try {
      await API.post("/auth/register", form);
      alert("Registered successfully. Please login.");
      navigate("/login");
    } catch (err) {
      const message = err?.response?.data?.message || "Registration failed";
      alert(`${message} ❌`);
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
          Register
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
            onClick={handleRegister}
            className="bg-purple-600 py-3 rounded text-white hover:bg-purple-700"
          >
            Register
          </button>

          <button
            onClick={() => navigate("/login")}
            className="border border-gray-600 py-3 rounded text-white hover:bg-gray-800"
          >
            Back to login
          </button>
        </div>
      </motion.div>
    </div>
  );
}
