const LineService = require("../services/line.services");

exports.register = async (req, res, next) => {
    try {
        console.log("[LineController][register] req.body:", req.body);
        const { name, prtn, targ, good, ngoo } = req.body;

        const successRes = await LineService.registerLine(name, prtn, targ, good, ngoo);
        console.log("[LineController][register] Register success:", successRes);

        res.json({ status: true, success: "Line Registered Successfully: " + successRes });
    } catch (error) {
        console.error("[LineController][register] Error:", error);
        next(error);
    }
};

exports.getLine = async (req, res, next) => {
    try {
        console.log("[LineController][getLine] Getting all lines...");
        let line = await LineService.getLineData();
        console.log("[LineController][getLine] Fetched lines:", line);

        res.json({ status: true, success: line });
    } catch (error) {
        console.error("[LineController][getLine] Error:", error);
        next(error);
    }
};

exports.deleteLine = async (req, res, next) => {
    try {
        console.log("[LineController][deleteLine] req.body:", req.body);
        const { id } = req.body;

        if (!id) {
            console.warn("[LineController][deleteLine] Missing ID in request body");
            return res.status(400).json({ status: false, message: "Missing ID in request body" });
        }

        console.log("[LineController][deleteLine] Deleting line with ID:", id);
        const deleteres = await LineService.deleteLine(id);

        if (!deleteres) {
            console.warn("[LineController][deleteLine] Line not found with ID:", id);
            return res.status(404).json({ status: false, message: "Line not found" });
        }

        console.log("[LineController][deleteLine] Delete success:", deleteres);
        res.json({ status: true, success: deleteres });
    } catch (error) {
        console.error("[LineController][deleteLine] Error:", error);
        next(error);
    }
};

exports.editLine = async (req, res, next) => {
    try {
        console.log("[LineController][editLine] req.body:", req.body);
        const { id, name } = req.body;

        if (!id || !name) {
            console.warn("[LineController][editLine] Missing ID or name in request body");
            return res.status(400).json({ status: false, message: "Missing ID or name in request body" });
        }

        console.log("[LineController][editLine] Editing line with ID:", id, " New name:", name);
        const editres = await LineService.editLine(id, name);

        if (!editres) {
            console.warn("[LineController][editLine] Line not found with ID:", id);
            return res.status(404).json({ status: false, message: "Line not found" });
        }

        console.log("[LineController][editLine] Edit success:", editres);
        res.json({ status: true, success: editres });
    } catch (error) {
        console.error("[LineController][editLine] Error:", error);
        next(error);
    }
};
