const router = require('express').Router();
const DeviceController = require("../controller/device.controller");

router.post('/deviceadd',DeviceController.register);

module.exports = router;