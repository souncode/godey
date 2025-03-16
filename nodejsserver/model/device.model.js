const mongoose = require('mongoose');
const db = require('../config/db');
const LineModel = require('./line.model')

const { Schema } = mongoose;

const deviceSchema = new Schema({
    line: {
        type: Schema.Types.ObjectId,
        ref: LineModel.modelName
    },
    stat: {
        type: String,
        required: true,
    },
    type: {
        type: String,  
        required: true, 
    },
    time: {
        type: String, 
        required: true, 
    },
    ctrl: [
        {
            inde: {
                type: String,
                required: true,
            },
            temp: {
                type: String,
                required: true,
            },
            setv: {
                type: String,
                required: true,
            },
            offs: {
                type: String,
                required: true,
            },
        }
    ]
});


const DeviceModel = db.model('device', deviceSchema);

module.exports = DeviceModel;