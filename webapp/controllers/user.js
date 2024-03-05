
const User = require('../models/user');
const bcrypt = require('bcrypt');


const registerUser = async (req, res) => {

  const username = req.body.username;

  // Validate username
  const emailRegex = /^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$/;
  if (!emailRegex.test(username)) {
    return res.status(400).send({ error: 'Invalid email address.' });
  }


  // Check if the username already exists
  const existingUser = await User.findOne({ where: { username } });
  if (existingUser) {
    return res.status(400).send({ error: 'Email already in use.' });
  }

  const user = await User.create(req.body);
  const userJson = user.toJSON();
  delete userJson.password;

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

  res.status(204).end();

}

const getUser = async (req, res) => {

  const user = await User.findOne({
    where: { username: req.username },
  });

  // Create a new object from the user data
  let userResponse = user.get({ plain: true });
  delete userResponse.password;

  res.status(200).send(userResponse);

}


module.exports = {
  registerUser,
  updateUser,
  getUser
}