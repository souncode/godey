const LineModel = require('../model/line.model');

class LineService {
    static async registerLine(name) {
        try {
            const addLine = new LineModel({ name });
            return await addLine.save();
        } catch (error) {
            throw error
        }
    }

    static async getLineData() {
        try {
            const lineData = await LineModel.find({});
            return lineData;
        } catch (error) {
            throw error;
        }
    }
}
module.exports = LineService;