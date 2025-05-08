const router = require('express').Router();
const LineController = require('../controller/line.controller');


router.post('/addline', LineController.register);
router.post('/getline', LineController.getLine);
router.post('/deleteline', LineController.deleteLine);
router.post('/editline', LineController.editLine);
module.exports = router;