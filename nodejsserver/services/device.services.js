const DeviceModel = require('../model/device_model');

class DeviceService {
    static async registerDevice(line,stat, type, time, ctrl) {
        try {
            const registerDevice = new DeviceModel({line,stat, type, time, ctrl });
            return await registerDevice.save();
        } catch (error) {
            throw error;
        }
    }
}

module.exports = DeviceService;
