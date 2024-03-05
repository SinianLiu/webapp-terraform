const express = require('express');
const router = express.Router();
const { authenticateToken } = require('./auth');



const { registerUser, updateUser, getUser } = require('./controllers/user'); // adjust the path as needed

router.post('/user', registerUser);
router.put('/user', authenticateToken, updateUser);
router.get('/user', authenticateToken, getUser);

module.exports = router;


