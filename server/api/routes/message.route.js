var express = require('express');
var router = express.Router();
const messageController = require('../controllers/message.controller');

/* GET messages. */
router.get('/', messageController.getMessages);

/* GET message by Id. */
router.get('/:id', messageController.getMessage);

/* Post message. */
router.post('/create', messageController.createMessage);

/* patch message. */
router.patch('/update/:id', messageController.updateMessage);

/* delete message. */
router.delete('/delete/:id', messageController.deleteMessage);

module.exports = router;
