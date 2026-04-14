import { DataTypes } from "sequelize";
import sequelize from "../config/db.js";

const User = sequelize.define("User", {
  email: {
    type: DataTypes.STRING,
    unique: true,
  },
  password: DataTypes.STRING,
});

export default User;