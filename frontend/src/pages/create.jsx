import { useState } from "react";
import { useNavigate } from "react-router-dom";
import API from "@/api/axios";

export default function Create() {
  const navigate = useNavigate();

  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [file, setFile] = useState(null);

  const handleCreate = async () => {
    try {
      const formData = new FormData();

      formData.append("title", title);
      formData.append("description", description);
      formData.append("image", file); // 🔥 file send

      await API.post("/posts", formData, {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      });

      alert("Post created 🚀");
      navigate("/");
    } catch (err) {
      console.log(err);
      alert("Error ❌");
    }
  };

  return (
    <div className="min-h-screen bg-[#0f172a] flex justify-center items-center">
      <div className="bg-[#1e293b] p-8 rounded-2xl w-full max-w-lg shadow-xl">
        <h2 className="text-white text-2xl mb-6 font-bold">
          Create Blog ✍️
        </h2>

        <div className="flex flex-col gap-4">
          <input
            placeholder="Title"
            className="p-3 rounded bg-gray-800 text-white"
            onChange={(e) => setTitle(e.target.value)}
          />

          <textarea
            placeholder="Description"
            className="p-3 rounded bg-gray-800 text-white"
            onChange={(e) => setDescription(e.target.value)}
          />

          {/* 🔥 FILE INPUT */}
          <input
            type="file"
            className="text-white"
            onChange={(e) => setFile(e.target.files[0])}
          />

          <button
            onClick={handleCreate}
            className="bg-purple-600 py-3 rounded text-white hover:bg-purple-700"
          >
            Upload 🚀
          </button>
        </div>
      </div>
    </div>
  );
}