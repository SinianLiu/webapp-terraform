const bcrypt = require('bcrypt');
const User = require('./models/user');


const authenticateToken = async (req, res, next) => {

  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(400).json({ error: 'Missing Authorization header' });
  }

  // Correctly parse the Basic auth string
  const base64Credentials = authHeader.split(' ')[1];
  const credentials = Buffer.from(base64Credentials, 'base64').toString('ascii');
  const [username, password] = credentials.split(':');

  if (!username || !password) {
    return res.status(400).json({ error: 'Invalid Authorization header - Missing username or password' });
  }

  const isUserAuthed = await validUser(username, password);

  if (!isUserAuthed) {
    return res.status(400).json({ error: 'Unauthorized - Wrong username or password' });
  }
  
  req.username = username;

  next();

};



//check User Authentication
const validUser = async (username, password) => {

  const user = await User.findOne({
    where: { username },
  });

  if (!user) {
    return false;
  }

  const isValidPassword = await bcrypt.compare(password, user.password);

  if (!isValidPassword) {
    return false;
  }

  return true;
};


module.exports = {
  authenticateToken
};

