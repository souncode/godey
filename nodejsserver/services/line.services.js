const LineModel = require('../model/line_model');
const DeviceModel = require('../model/device_model')

class LineService{
    static async registerLine(name){
        try{
            const addLine = new LineModel({name});
            return await addLine.save();
        }catch(error){
            throw error
        }
    }

}
module.exports = LineService;