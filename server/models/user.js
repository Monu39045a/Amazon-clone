const mongoose = require("mongoose");
const { productSchema } = require("./product");

const userSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (email) => {
        return String(email)
          .toLowerCase()
          .match(
            /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
          );
      },
      message: "Please enter a valid email address",
    },
  },
  password: {
    required: true,
    type: String,
    validator: (value) => {
      return value.length > 6;
    },
    message: "Please enter a long Password",
  },
  address: {
    type: String,
    default: "",
  },
  type: {
    type: String,
    default: "user",
  },

  // For cart we need Product details and quantity, i.e we are using productSchema
  cart: [
    {
      product: productSchema,
      quantity: {
        type: Number,
        required: true,
      },
    },
  ],
});

const User = mongoose.model("User", userSchema);
module.exports = User;
