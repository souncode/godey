const router = require('express').Router();
const DeviceController = require("../controller/device.controller");

router.post('/deviceadd',DeviceController.register);
router.get('/getdevice',DeviceController.getDevice)

module.exports = router;