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