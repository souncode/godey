const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;
const lineSchema = new Schema({
    name: {
        type: String,
        lowercase: true,
        require: true
    }
});
const LineModel = db.model('line',lineSchema);

module.exports = LineModel;