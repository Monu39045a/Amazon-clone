const express = require("express");
const productRouter = express.Router();
const Product = require("../models/product");
const auth = require("../middleware/auth");

productRouter.get("/api/products", auth, async (req, res) => {
  try {
    let category = req.query.category;
    // console.log(category);
    if (!category) {
      return res.status(400).json({ error: "Category is required" });
    }

    let productData = await Product.find({ category: category });
    // console.log(productData);
    res.json(productData);
  } catch (e) {
    console.error(e.message);
    res.status(500).json({ error: e.message });
  }
});

// /api/products/search/:name/:great
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    let search = req.params.name;
    // console.log(search);
    let productData = await Product.find({
      name: { $regex: search, $options: "i" }, // built in regex provided by mongodb
    });
    // console.log(productData);
    res.json(productData);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//Api to post the rating
productRouter.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    // console.log("hello" + id);
    if (!id || !rating) {
      return res
        .status(400)
        .json({ error: "Missing required fields (id and rating)" });
    }

    let product = await Product.findById(id);
    if (!product) {
      return res.status(400).json({ error: "Product not found" });
    }

    // const existingRating = product.rating?.find((r) => r.userId == req.user);
    // for (let i = 0; i < product.rating.length; ++i) {
    //   // req.user because of the auth middleware
    //   if (product.rating[i].userId == req.user) {
    //     product.rating.splice(i, 1); // remove that particular rating
    //     break;
    //   }
    // }

    let existingRatingIndex = product.rating?.findIndex(
      (r) => r.userId == req.user
    );

    if (existingRatingIndex !== -1) {
      product.rating.splice(existingRatingIndex, 1);
    }

    let ratingSchema = { userId: req.user, rating: rating };
    product.rating.push(ratingSchema);

    await product.save();

    res.json({ message: "Product rating updated successfully" });
  } catch (e) {
    // console.log(e);
    res.status(500).json({ error: e.message });
  }
});

productRouter.get("/api/deal-of-the-day", auth, async (req, res) => {
  try {
    let products = await Product.find({});

    products = products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;
      for (let i = 0; i < a.rating.length; ++i) {
        aSum += a.rating[i].rating;
      }
      for (let i = 0; i < b.rating.length; ++i) {
        bSum += b.rating[i].rating;
      }

      return aSum < bSum ? 1 : -1;
    });
    res.json(products[0]);
  } catch (e) {
    res.json({ error: e.message });
  }
});

module.exports = productRouter;
