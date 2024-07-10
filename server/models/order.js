const moongoose = require("mongoose");
const { productSchema } = require("./product");

const orderSchema = moongoose.Schema({
  products: [
    {
      product: productSchema,
      quantity: {
        type: Number,
        required: true,
      },
    },
  ],
  totalPrice: {
    type: Number,
    required: true,
  },
  address: {
    type: String,
    required: true,
  },
  userId: {
    type: String,
    required: true,
  },
  orderAt: {
    type: Number,
    required: true,
  },
  status: {
    type: Number,
    default: 0, //0 - orderd , 1-completed,2-
  },
});

const Order = moongoose.model("Order", orderSchema);
module.exports = Order;
