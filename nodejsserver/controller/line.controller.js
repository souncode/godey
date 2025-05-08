const LineService = require("../services/line.services");

exports.register = async (req, res, next) => {

    try {
        const { name, prtn, targ, good, ngoo } = req.body;
        const successRes = await LineService.registerLine(name, prtn, targ, good, ngoo);
        res.json({ status: true, success: "Line Registered Successfully :" + successRes })
    } catch (error) {
        throw error
    }
}
exports.getLine = async (req, res, next) => {

    try {
        let line = await LineService.getLineData();
        res.json({ status: true, success: line })
    } catch (error) {
        throw error
    }
}
exports.deleteLine = async (req, res, next) => {
    try {
        const { id } = req.body;
        console.log("req.body is:", req.body);
        console.log("Received ID to delete:", id);
        const deleteres = await LineService.deleteLine(id);
        if (!deleteres) {
            return res.status(404).json({ status: false, message: "Line not found" });
        }
        res.json({ status: true, success: deleteres });
    } catch (error) {
        next(error);
    }
};
exports.editLine = async (req, res, next) => {
    try {
        const { id, name } = req.body;
        console.log("req.body is:", req.body);
        console.log("Received ID to edit:", id);
        const editres = await LineService.editLine(id, name);
        if (!editres) {
            return res.status(404).json({ status: false, message: "Line not found" });
        }
        res.json({ status: true, success: editres });
    } catch (error) {
        next(error);
    }
};