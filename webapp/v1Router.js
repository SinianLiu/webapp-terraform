const express = require('express');
const router = express.Router();
const { authenticateToken } = require('./auth');
const { registerUser, updateUser, getUser, deleteUser, verifyUser } = require('./controllers/user');

const { checkHealthz } = require('./controllers/healthCheck');



router.post('/user', registerUser);
router.put('/user', authenticateToken, updateUser);
router.get('/user', authenticateToken, getUser);
router.get('/healthz', checkHealthz);
router.delete('/user/', authenticateToken, deleteUser);

// for verification link
router.get('/user/verify', verifyUser);

module.exports = router;
