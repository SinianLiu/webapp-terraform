const express = require('express');
const bodyParser = require('body-parser');
const { checkHealthz } = require('./controllers/healthCheck');
const v1Router = require('./v1Router');


const sequelize = require('./sequelize');
const UserModel = require('./models/user');
const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


UserModel.init(sequelize); // Initialize User model
sequelize.sync({ force: false })


app.use('/healthz', checkHealthz);
app.use('/v2', v1Router);


module.exports = app;
