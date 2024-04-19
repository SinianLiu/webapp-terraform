
const User = require('../models/user');
const bcrypt = require('bcrypt');


const { userLogger: logger } = require('../loggers');
const { PubSub } = require('@google-cloud/pubsub');

const pubsub = new PubSub();


const registerUser = async (req, res) => {

  const username = req.body.username;

  // Validate username
  const emailRegex = /^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$/;
  if (!emailRegex.test(username)) {
    logger.warn(); ('Invalid email address');
    return res.status(400).send({ error: 'Invalid email address.' });
  }

  // Check if the username already exists
  const existingUser = await User.findOne({ where: { username } });
  if (existingUser) {
    logger.warn('Email already in use');
    return res.status(400).send({ error: 'Email already in use.' });
  }

  req.body.status = 'Pending';
  const user = await User.create(req.body);

  const userJson = user.toJSON();
  delete userJson.password;
  delete userJson.token;
  delete userJson.token_creation_time;
  delete userJson.token_expiration_time;

  // Publish a message to the topic
  const userJson_for_cloud = { username: userJson.username };
  const topicName = 'verify_email';
  const data = Buffer.from(JSON.stringify(userJson_for_cloud));
  await pubsub.topic(topicName).publishMessage({ data });

  logger.info(`User ${username} registered successfully`);
  res.status(201).send(userJson);
}


const updateUser = async (req, res) => {

  const user = await User.findOne({
    where: { username: req.username },
  });

  const updates = Object.keys(req.body);
  const allowedUpdates = ['first_name', 'last_name', 'password'];
  const isValidOperation = updates.every((update) => allowedUpdates.includes(update));

  if (!isValidOperation) {
    logger.error('Invalid update operation');
    return res.status(400).send({ error: 'You can only update your First Name, Last Name and Password!' });
  }

  updates.forEach((update) => user[update] = req.body[update]);

  if (req.body.password) {
    const salt = await bcrypt.genSalt();
    user.password = await bcrypt.hash(req.body.password, salt);
  }


  // Update the account_updated field
  user.account_updated = new Date();
  await user.save();

  logger.info(`User ${req.username} updated successfully`);
  res.status(204).end();

}

const getUser = async (req, res) => {

  const user = await User.findOne({
    where: { username: req.username },
  });

  // Create a new object from the user data
  let userResponse = user.get({ plain: true });
  delete userResponse.password;

  logger.info(`User ${req.username} fetched successfully`);
  res.status(200).send(userResponse);

}



const deleteUser = async (req, res) => {

  const user = await User.findOne({
    where: { id: req.query.id },
  });

  if (!user) {
    logger.warn(`User not found!`);
    return res.status(404).send({ error: 'User not found.' });
  }

  await user.destroy();

  logger.info(`User was deleted successfully`);
  res.status(204).end();
}


const verifyUser = async (req, res) => {

  const user = await User.findOne({ where: { username: req.query.username } });

  if (!user) {
    logger.warn(`User ${req.username} not found!`);
    return res.status(404).send({ error: 'User not found.' });
  }

  // Compare the current time with the token expiration time
  const currentTime = new Date();
  if (currentTime > user.token_expiration_time) {

    if (user.status === 'Verified') {
      logger.warn(`User ${req.username} is already verified`);
      return res.status(400).send('<p>User already verified!</p>');
    }

    logger.warn(`User ${req.username} is not actived`);
    return res.status(403).send('<p>Your verification link has expired!</p>');
  }

  // Update the user's status to 'Verified'
  user.status = 'Verified';
  await user.save();

  res.status(200).send('<p>User verified.</p>');

}

module.exports = {
  registerUser,
  updateUser,
  getUser,
  verifyUser,
  deleteUser
}
