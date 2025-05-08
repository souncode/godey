const DeviceModel = require('../model/device.model');
const mongoose = require('mongoose');
class DeviceService {
    static async registerDevice(line, stat, type, time, ctrl, moni) {
        try {
            const registerDevice = new DeviceModel({ line, stat, type, time, ctrl, moni });
            return await registerDevice.save();
        } catch (error) {
            throw error;
        }
    }

    static async getDeviceData(line) {
        try {
            const deviceData = await DeviceModel.find({ line });
            return deviceData;
        } catch (error) {
            throw error;
        }
    }

    static async deleteDevice(id) {
        try {
            const deviceDeleter = await DeviceModel.findOneAndDelete({ _id: new mongoose.Types.ObjectId(id) });
            return deviceDeleter;
        } catch (error) {
            throw error;
        }
    }

    static async editDevice(id, newLine, newStat) {
        try {
            const updatedDevice = await DeviceModel.findByIdAndUpdate(
                new mongoose.Types.ObjectId(id),
                { line: new mongoose.Types.ObjectId(newLine), stat: newStat },
                { new: true }
            );
            return updatedDevice;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = DeviceService;
