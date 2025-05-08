const DeviceService = require("../services/device.services");

exports.register = async (req, res, next) => {

    try {
        const {line, stat, type, time, ctrl,moni } = req.body;
        let device = await DeviceService.registerDevice(line, stat, type, time, ctrl,moni);
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
exports.deleteDevice = async (req, res, next) => {

    try {
        const { id } = req.body;
        console.log("req.body is:", req.body);
        console.log("Received ID to delete:", id); 
        const deleteres = await DeviceService.deleteDevice(id);
        if (!deleteres) {
            return res.status(404).json({ status: false, message: "Device not found" });
        }
        res.json({ status: true, success: deleteres });
    } catch (error) {
        next(error);
    }
} 
exports.editDevice = async (req, res, next) => {

    try {
        const { id ,line,stat} = req.body;
        console.log("req.body is:", req.body);
        console.log("Received ID to edit:", id); 
        const editRes = await DeviceService.editDevice(id,line,stat);
        if (!editRes) {
            return res.status(404).json({ status: false, message: "Device not found" });
        }
        res.json({ status: true, success: editRes });
    } catch (error) {
        next(error);
    }
} 