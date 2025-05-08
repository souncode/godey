const DeviceModel = require('../model/device.model');
const mongoose = require('mongoose');

class DeviceService {
    static async registerDevice(line, stat, type, time, ctrl, moni) {
        try {
            console.log("[DeviceService][registerDevice] Registering device with:", { line, stat, type, time, ctrl, moni });
            const registerDevice = new DeviceModel({ line, stat, type, time, ctrl, moni });
            const savedDevice = await registerDevice.save();
            console.log("[DeviceService][registerDevice] Saved device:", savedDevice);
            return savedDevice;
        } catch (error) {
            console.error("[DeviceService][registerDevice] Error:", error);
            throw error;
        }
    }

    static async getDeviceData(line) {
        try {
            console.log("[DeviceService][getDeviceData] Fetching devices for line:", line);
            const deviceData = await DeviceModel.find({ line });
            console.log("[DeviceService][getDeviceData] Found devices:", deviceData.length);
            return deviceData;
        } catch (error) {
            console.error("[DeviceService][getDeviceData] Error:", error);
            throw error;
        }
    }

    static async deleteDevice(id) {
        try {
            console.log("[DeviceService][deleteDevice] Deleting device with ID:", id);
            if (!mongoose.Types.ObjectId.isValid(id)) {
                console.warn("[DeviceService][deleteDevice] Invalid ObjectId:", id);
                return null;
            }
            const deviceDeleter = await DeviceModel.findOneAndDelete({ _id: new mongoose.Types.ObjectId(id) });
            console.log("[DeviceService][deleteDevice] Deleted device:", deviceDeleter);
            return deviceDeleter;
        } catch (error) {
            console.error("[DeviceService][deleteDevice] Error:", error);
            throw error;
        }
    }

    static async editDevice(id, newLine, newStat) {
        try {
            console.log("[DeviceService][editDevice] Editing device ID:", id, "New line:", newLine, "New stat:", newStat);
            if (!mongoose.Types.ObjectId.isValid(id) || !mongoose.Types.ObjectId.isValid(newLine)) {
                console.warn("[DeviceService][editDevice] Invalid ObjectId for id or line");
                return null;
            }

            const updatedDevice = await DeviceModel.findByIdAndUpdate(
                new mongoose.Types.ObjectId(id),
                { line: new mongoose.Types.ObjectId(newLine), stat: newStat },
                { new: true }
            );
            console.log("[DeviceService][editDevice] Updated device:", updatedDevice);
            return updatedDevice;
        } catch (error) {
            console.error("[DeviceService][editDevice] Error:", error);
            throw error;
        }
    }
}

module.exports = DeviceService;
