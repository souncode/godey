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