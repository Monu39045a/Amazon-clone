//Import from packages
// require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
//Import from other files
const authRouter = require("./routes/auth");

// INIT
const PORT = 3000;
const app = express();
const DB =
  "mongodb+srv://abhishek39045:Monu39045a%40@cluster0.24izqie.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

// const DB = process.env.URI;

// middleware
// app.use(express.json());
app.use(bodyParser.json());
app.use(authRouter);

//Connection
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connected to MongoDB");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`The server is running on PORT : ${PORT}`);
});
