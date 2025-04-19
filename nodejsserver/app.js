const express = require('express');
const cors = require('cors'); // ✅ Import CORS
const bodyParser = require('body-parser');
const lineRouter = require('./routers/line.router');
const deviceRouter = require('./routers/device.router');

const app = express();

// ✅ Bật CORS cho tất cả domain (tạm thời)
app.use(cors());
app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/', lineRouter);
app.use('/', deviceRouter);

module.exports = app;
