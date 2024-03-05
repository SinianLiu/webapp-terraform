const express = require('express');
const bodyParser = require('body-parser');
const { checkHealthz } = require('./controllers/healthCheck');
const v1Router = require('./v1Router');
const router = express.Router();
require('dotenv').config();


const Sequelize = require('sequelize');
const UserModel = require('./models/user');


const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


// Initialize Sequelize and models
const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USERNAME,
  process.env.DB_PASSWORD, {
  host: process.env.DB_HOST,
  dialect: process.env.DB_DIALECT
});

UserModel.init(sequelize); // Initialize User model

sequelize.sync({ force: false })
  .then(() => {
    console.log(`Database & tables created!`)
  });



app.use('/healthz', checkHealthz);
app.use('/v1', v1Router);


module.exports = app;
