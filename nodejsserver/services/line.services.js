const LineModel = require('../model/line.model');
const mongoose = require('mongoose');

class LineService {
    static async registerLine(name, prtn, targ, good, ngoo) {
        try {
            console.log("[LineService][registerLine] Creating line with:", { name, prtn, targ, good, ngoo });
            const addLine = new LineModel({ name, prtn, targ, good, ngoo });
            const savedLine = await addLine.save();
            console.log("[LineService][registerLine] Saved line:", savedLine);
            return savedLine;
        } catch (error) {
            console.error("[LineService][registerLine] Error:", error);
            throw error;
        }
    }

    static async getLineData() {
        try {
            console.log("[LineService][getLineData] Fetching all lines");
            const lineData = await LineModel.find({});
            console.log("[LineService][getLineData] Found lines:", lineData.length);
            return lineData;
        } catch (error) {
            console.error("[LineService][getLineData] Error:", error);
            throw error;
        }
    }

    static async deleteLine(id) {
        try {
            console.log("[LineService][deleteLine] Deleting line with ID:", id);
            if (!mongoose.Types.ObjectId.isValid(id)) {
                console.warn("[LineService][deleteLine] Invalid ObjectId:", id);
                return null;
            }
            const lineDeleter = await LineModel.findOneAndDelete({ _id: new mongoose.Types.ObjectId(id) });
            console.log("[LineService][deleteLine] Deleted line:", lineDeleter);
            return lineDeleter;
        } catch (error) {
            console.error("[LineService][deleteLine] Error:", error);
            throw error;
        }
    }

    static async editLine(id, newName) {
        try {
            console.log("[LineService][editLine] Editing line ID:", id, "New name:", newName);
            if (!mongoose.Types.ObjectId.isValid(id)) {
                console.warn("[LineService][editLine] Invalid ObjectId:", id);
                return null;
            }
            const updatedLine = await LineModel.findByIdAndUpdate(
                new mongoose.Types.ObjectId(id),
                { name: newName },
                { new: true }
            );
            console.log("[LineService][editLine] Updated line:", updatedLine);
            return updatedLine;
        } catch (error) {
            console.error("[LineService][editLine] Error:", error);
            throw error;
        }
    }
}

