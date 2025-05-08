const DeviceService = require("../services/device.services");

exports.register = async (req, res, next) => {
    try {
        console.log("[DeviceController][register] req.body:", req.body);
        const { line, stat, type, time, ctrl, moni } = req.body;

        if (!line || !stat || !type || !time || !ctrl || !moni) {
            console.warn("[DeviceController][register] Missing required fields");
            return res.status(400).json({ status: false, message: "Missing required fields" });
        }

        let device = await DeviceService.registerDevice(line, stat, type, time, ctrl, moni);
        console.log("[DeviceController][register] Register success:", device);

        res.json({ status: true, success: device });
    } catch (error) {
        console.error("[DeviceController][register] Error:", error);
        next(error);
    }
};

exports.getDevice = async (req, res, next) => {
    try {
        console.log("[DeviceController][getDevice] req.body:", req.body);
        const { line } = req.body;

        if (!line) {
            console.warn("[DeviceController][getDevice] Missing 'line' in request body");
            return res.status(400).json({ status: false, message: "Missing 'line' in request body" });
        }

        let device = await DeviceService.getDeviceData(line);
        console.log("[DeviceController][getDevice] Fetched devices:", device);

        res.json({ status: true, success: device });
    } catch (error) {
        console.error("[DeviceController][getDevice] Error:", error);
        next(error);
    }
};

exports.deleteDevice = async (req, res, next) => {
    try {
        console.log("[DeviceController][deleteDevice] req.body:", req.body);
        const { id } = req.body;

        if (!id) {
            console.warn("[DeviceController][deleteDevice] Missing ID in request body");
            return res.status(400).json({ status: false, message: "Missing ID in request body" });
        }

        console.log("[DeviceController][deleteDevice] Deleting device with ID:", id);
        const deleteres = await DeviceService.deleteDevice(id);

        if (!deleteres) {
            console.warn("[DeviceController][deleteDevice] Device not found with ID:", id);
            return res.status(404).json({ status: false, message: "Device not found" });
        }

        console.log("[DeviceController][deleteDevice] Delete success:", deleteres);
        res.json({ status: true, success: deleteres });
    } catch (error) {
        console.error("[DeviceController][deleteDevice] Error:", error);
        next(error);
    }
};

exports.editDevice = async (req, res, next) => {
    try {
        console.log("[DeviceController][editDevice] req.body:", req.body);
        const { id, line, stat } = req.body;

        if (!id || !line || !stat) {
            console.warn("[DeviceController][editDevice] Missing fields (id, line, or stat)");
            return res.status(400).json({ status: false, message: "Missing required fields (id, line, stat)" });
        }

        console.log("[DeviceController][editDevice] Editing device with ID:", id);
        const editRes = await DeviceService.editDevice(id, line, stat);

        if (!editRes) {
            console.warn("[DeviceController][editDevice] Device not found with ID:", id);
            return res.status(404).json({ status: false, message: "Device not found" });
        }

        console.log("[DeviceController][editDevice] Edit success:", editRes);
        res.json({ status: true, success: editRes });
    } catch (error) {
        console.error("[DeviceController][editDevice] Error:", error);
        next(error);
    }
};
