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

            },
            temp: {
                type: String,

            },
            setv: {
                type: String,

            },
            offs: {
                type: String,

            },
        }
    ],
    moni: [

        {
            prtn: {
                type: String,
            },
            good: {
                type: String,
            },
            ngoo: {
                type: String,
            },
            targ: {
                type: String,
            },
        }
    ],
});


const DeviceModel = db.model('device', deviceSchema);

module.exports = DeviceModel;