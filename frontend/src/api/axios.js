import axios from "axios";

const API = axios.create({
 baseURL: "http://terraform-task-staging-alb-512188530.ap-southeast-1.elb.amazonaws.com/api",
});

API.interceptors.request.use((req) => {
  const token = localStorage.getItem("token");

  if (token) {
    req.headers.Authorization = `Bearer ${token}`;
  }

  return req;
});

export default API;