const DeviceModel = require('../model/device.model');

class DeviceService {
    static async registerDevice(line, stat, type, time, ctrl) {
        try {
            const registerDevice = new DeviceModel({ line, stat, type, time, ctrl });
            return await registerDevice.save();
        } catch (error) {
            throw error;
        }
    }

    static async getDeviceData(line) {
        try {
            const deviceData = await DeviceModel.find({line});
            return deviceData;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = DeviceService;
