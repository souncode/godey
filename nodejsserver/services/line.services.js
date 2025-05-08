const LineModel = require('../model/line.model');
const mongoose = require('mongoose');
class LineService {
    static async registerLine(name, prtn, targ, good, ngoo) {
        try {
            const addLine = new LineModel({ name, prtn, targ, good, ngoo });
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

    static async deleteLine(id) {
        try {
            const lineDeleter = await LineModel.findOneAndDelete({ _id: new mongoose.Types.ObjectId(id) });
            return lineDeleter;
        } catch (error) {
            throw error;
        }
    }

    static async editLine(id, newName) {
        try {
            const updatedLine = await LineModel.findByIdAndUpdate(
                new mongoose.Types.ObjectId(id),
                { name: newName },
                { new: true } 
            );
            return updatedLine;
        } catch (error) {
            throw error;
        }
    }
}
module.exports = LineService;