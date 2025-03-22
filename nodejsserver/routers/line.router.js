const router = require('express').Router();
const LineController = require('../controller/line.controller');


router.post('/addline',LineController.register);

module.exports = router;