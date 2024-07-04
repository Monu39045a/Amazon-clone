const express = require("express");
const auth = require("../middleware/auth");
const userRouter = express.Router();
const User = require("../models/user");
const { Product } = require("../models/product");

userRouter.post("/api/add-product-to-cart", auth, async (req, res) => {
  // We can store the cart details of a user into a provider so that we don't need to fetch it again and again
  try {
    const { id } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }

    const cartProduct = user.cart.find((item) =>
      item.product._id.equals(product._id)
    );

    if (cartProduct) {
      cartProduct.quantity += 1;
    } else {
      user.cart.push({ product, quantity: 1 });
    }

    // both works
    // if (user.cart.length === 0) {
    //   console.log("1");
    //   user.cart.push({ product, quantity: 1 });
    // } else {
    //   let isProductFound = false;
    //   for (let i = 0; i < user.cart.length; ++i) {
    //     if (user.cart[i].product._id.equals(product._id)) {
    //       isProductFound = true;
    //     }
    //   }

    //   if (isProductFound) {
    //     let productt = user.cart.find((item) =>
    //       item.product._id.equals(product._id)
    //     );
    //     productt.quantity += 1;
    //   } else {
    //     user.cart.push({ product, quantity: 1 });
    //   }
    // }

    user = await user.save();
    // console.log(user);
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.delete("/api/remove-product", auth, async (req, res) => {
  try {
    const { productId } = req.body;
    console.log(productId);
    let user = await User.findById(req.user);

    // let index = -1;
    // for (let i = 0; i < user.cart.length; ++i) {
    //   if (user.cart[i].product._id.equals(productId)) {
    //     console.log(user.cart);
    //     user.cart[i].quantity -= 1;
    //     index = i;
    //     break;
    //   }
    // }

    // const cartProductIndex = user.cart.findIndex((item) =>
    //   item.product._id.equals(productId)
    // );
    // or
    const cartProductIndex = user.cart.findIndex((item) => {
      return item.product._id.equals(productId);
    });
    console.log(cartProductIndex);
    user.cart[cartProductIndex].quantity -= 1;

    if (user.cart[cartProductIndex].quantity == 0) {
      user.cart.splice(cartProductIndex, 1);
    }

    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = userRouter;
