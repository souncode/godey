const LineModel = require('../model/line.model');
const DeviceModel = require('../model/device.model')

class LineService {
    static async registerLine(name) {
        try {
            const addLine = new LineModel({ name });
            return await addLine.save();
        } catch (error) {
            throw error
        }
    }

}
module.exports = LineService;