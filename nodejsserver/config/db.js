const mongoose = require('mongoose');

const connection = mongoose.createConnection('mongodb://localhost:27017/flutter').on('open', () => {
    console.log("MongoDB connected");
}).on('error', () => {
    console.log(" Create MongoDB connection fail");
});

module.exports = connection;