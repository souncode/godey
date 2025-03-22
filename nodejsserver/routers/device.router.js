const router = require('express').Router();
const DeviceController = require("../controller/device.controller");

router.post('/adddevice',DeviceController.register);
router.post('/getdevice',DeviceController.getDevice)

module.exports = router;