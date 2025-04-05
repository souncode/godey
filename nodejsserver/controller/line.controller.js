const LineService = require("../services/line.services");

exports.register = async (req, res, next) => {

    try {
        const { name } = req.body;
        const successRes = await LineService.registerLine(name);
        res.json({ status: true, success: "Line Registered Successfully" })
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