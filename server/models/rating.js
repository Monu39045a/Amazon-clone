const mongoose = require("mongoose");

//Note : we won't be creating a model out of it , as we only need the structure
//If we create a model then it will create an entirely new model : we get _id and _version which we won't requre
const ratingSchema = mongoose.Schema({
  userId: {
    type: String, //String because the we are getting from the frontend will be String and not OBJECTID
    required: true,
  },
  rating: {
    type: Number,
    required: true,
  },
});

module.exports = ratingSchema;
