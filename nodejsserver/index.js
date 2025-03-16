const app = require('./app');
const db = require('./config/db')
const LineModel = require('./model/line.model')
const DeviceModel = require('./model/device.model')


const port = 3000;


app.get('/', (req, res) => {
    res.send("Get from server successfully")
});
app.listen(port, "0.0.0.0", () => {
    console.log(`Server running at http://0.0.0.0:${port}`);
});