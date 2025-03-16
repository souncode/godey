const router = require('express').Router();
const LineController = require('../controller/line.controller');


router.post('/lineadd',LineController.register);

module.exports = router;