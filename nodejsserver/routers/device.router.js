const router = require('express').Router();
const DeviceController = require("../controller/device.controller");

router.post('/deviceadd',DeviceController.add);

module.exports = router;