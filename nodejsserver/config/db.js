const mongoose = require('mongoose');

const connection = mongoose.createConnection('mongodb+srv://root:sonknight1@soun.qeqto.mongodb.net').on('open', () => {
    console.log("MongoDB connected");
}).on('error', () => {
    console.log(" Create MongoDB connection fail");
});

module.exports = connection;