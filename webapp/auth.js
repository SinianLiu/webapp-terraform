const bcrypt = require('bcrypt');
const User = require('./models/user');
const { authLogger: logger } = require('./loggers');


const authenticateToken = async (req, res, next) => {

  const authHeader = req.headers.authorization;

  if (!authHeader) {
    logger.error('Missing Authorization header');
    return res.status(400).json({ error: 'Missing Authorization header' });
  }

  // Correctly parse the Basic auth string
  const base64Credentials = authHeader.split(' ')[1];
  const credentials = Buffer.from(base64Credentials, 'base64').toString('ascii');
  const [username, password] = credentials.split(':');

  if (!username || !password) {
    logger.error('Invalid Authorization header - Missing username or password');
    return res.status(400).json({ error: 'Invalid Authorization header - Missing username or password' });
  }



  // Check if user exists
  const user = await User.findOne({ where: { username: username } });
  if (!user) {
    logger.error('User not found');
    return res.status(404).json({ error: 'User not found' });
  }


  const isUserVerified = await checkStatus(username);
  const isUserAuthed = await validUser(username, password);

  if (!isUserVerified) {
    logger.error('User is not active and needs to be verified');
    return res.status(403).json({ error: 'User is not active and needs to be verified!' });
  }

  if (!isUserAuthed) {
    logger.error('Unauthorized - Wrong username or password');
    return res.status(400).json({ error: 'Unauthorized - Wrong username or password' });
  }

  logger.info(`User ${username} authenticated successfully`);
  req.username = username;

  next();

};



//check User Authentication
const validUser = async (username, password) => {

  const user = await User.findOne({
    where: { username },
  });

  if (!user) {
    logger.error(`User ${username} not found`);
    return false;
  }

  const isValidPassword = await bcrypt.compare(password, user.password);

  if (!isValidPassword) {
    logger.error(`Invalid password for user ${username}`);
    return false;
  }

  return true;
};


// check User Status
const checkStatus = async (username) => {

  const user = await User.findOne({
    where: { username },
  });

  return user.status === 'Verified';
}




module.exports = {
  checkStatus,
  authenticateToken
};
