const DeviceService = require("../services/device.services");

exports.register = async (req, res, next) => {

    try {
        const {line, stat, type, time, ctrl } = req.body;
        let device = await DeviceService.registerDevice(line, stat, type, time, ctrl);
        res.json({ status: true, success: device})
    } catch (error) {
        throw error
    }
} 

exports.getDevice = async (req, res, next) => {

    try {
        const {line} = req.body;
        let device = await DeviceService.getDeviceData(line);
        res.json({ status: true, success: device})
    } catch (error) {
        throw error
    }
} 