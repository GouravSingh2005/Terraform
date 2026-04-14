import { Sequelize } from "sequelize";
import dotenv from "dotenv";

// 🔥 ensure env yahi load ho
dotenv.config({ path: ".env.local" });

console.log("DB DEBUG:", {
  user: process.env.DB_USER,
  pass: process.env.DB_PASSWORD,
});

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    dialect: "mysql",
    logging: false,
  }
);

export default sequelize;