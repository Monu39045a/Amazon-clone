const express = require("express");
const adminRouter = express.Router();
const admin = require("../middleware/admin");
const { Product } = require("../models/product");

adminRouter.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, quantity, price, images, category } = req.body;
    let product = new Product({
      name,
      description,
      quantity,
      price,
      images,
      category,
    });
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.get("/admin/get-products", admin, async (req, res) => {
  try {
    const Products = await Product.find({});
    // console.log(Products);
    res.json(Products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.delete("/admin/delete-product", admin, async (req, res) => {
  try {
    const { id } = req.body;
    // console.log(id);
    const product = await Product.findByIdAndDelete(id);
    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = adminRouter;
