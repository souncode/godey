const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;
const lineSchema = new Schema({
    name: {
        type: String,
        lowercase: true,
        require: true
    },
    prtn: {
        type: String,
    },
    targ: {
        type: String,
    },
    good: {
        type: String,
    },
    ngoo: {
        type: String,
    }
});
const LineModel = db.model('line', lineSchema);

module.exports = LineModel;