const express = require("express");
const authRouter = express.Router();
const User = require("../models/user");
const bcrypt = require("bcryptjs");

// authRouter.get("/api/user", (req, res) => {
//   res.json({ message: "Hello" });
// });

authRouter.post("/api/signup", async (req, res) => {
  const { name, email, password } = req.body;
  // console.log(name);

  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(409)
        .json({ message: "User with same Email already exist" });
    }

    // Hash the password
    const hashPassword = await bcrypt.hash(password, 10);

    //post that data into database
    let user = new User({ name, email, password: hashPassword });
    user = await user.save();

    //return that data to the user
    const userwithoutpassword = { ...user._doc, password: undefined };
    res.status(200).json(userwithoutpassword);
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;
