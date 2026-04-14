import { DataTypes } from "sequelize";
import sequelize from "../config/db.js";

const Post = sequelize.define("Post", {
  title: DataTypes.STRING,
  description: DataTypes.TEXT,
  image: DataTypes.TEXT("long"),
});

export default Post;