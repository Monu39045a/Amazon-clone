const express = require("express");
const adminRouter = express.Router();
const admin = require("../middleware/admin");
const { Product } = require("../models/product");
const Order = require("../models/order");

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

adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
  try {
    console.log("hi");
    const { id, status } = req.body;
    console.log(id);
    console.log(status);
    let order = await Order.findById(id);
    order.status = status; // pr order.status+=1
    console.log(order);
    order = order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.get("/admin/analytics", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    let totalEarning = 0.0;
    for (let i = 0; i < orders.length; ++i) {
      for (let j = 0; j < orders[i].products.length; ++j) {
        let productData = orders[i].products[j];
        totalEarning += productData.quantity * productData.product.price;
      }
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = adminRouter;
