const router = require('express').Router();
const LineController = require('../controller/line.controller');


router.post('/addline',LineController.register);
router.post('/getline',LineController.getLine);

module.exports = router;