const jwt = require("jsonwebtoken");
const User = require("../models/user");

const admin = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");

    if (!token) {
      res.status(401).json({ message: "No auth token , access denied" });
    }

    const verified = jwt.verify(token, "passwordKey");
    if (!verified)
      return res
        .status(401)
        .json({ message: "Token verification failed, Authorization Denied" });

    const user = await User.findById(verified.id);
    // console.log(user); //to see user details
    if (user.type == "user" || user.type == "seller")
      return res.status(401).json({ message: "You are not an admin " });

    req.user = verified.id; //adding id to the req.user
    req.token = token;
    next();
  } catch (e) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = admin;
