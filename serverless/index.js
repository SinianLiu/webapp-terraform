
'use strict';

const functions = require('@google-cloud/functions-framework');
const { Client } = require('pg');
const { v4: uuidv4 } = require('uuid');


let DOMAIN = 'sinianliu.me';
let api_key_val = process.env.API_KEY;
// let api_key_val = "f65a0b441829301d3ec7a2df685a71b8-f68a26c9-7ef6afd6";
const mailgun = require('mailgun-js')({ apiKey: api_key_val, domain: DOMAIN });


const sendMail = function (receiver_email, verificationLink) {
  let email_body =
    `<p>Click this link to verify your email address</p><a href="${verificationLink}">${verificationLink}</a>`;

  const data = {
    "from": 'info@sinianliu.me',
    "to": receiver_email,
    "subject": 'Verify your email address',
    "html": email_body
  };

  mailgun.messages().send(data, (error, body) => {
    if (error) console.log(error)
    else console.log(body);
  });
}



const updateDataToUserTable = async (username, token, tokenCreationTime, tokenExpirationTime) => {

  const client = new Client({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: 5432,
  });

  const query = `
  UPDATE "Users"
  SET token = $1, token_creation_time = $2, token_expiration_time = $3, status = 'Pending'
  WHERE username = $4
  `;

  try {
    await client.connect();
    await client.query(query, [token, tokenCreationTime, tokenExpirationTime, username])
    console.log('Table is successfully created');
  } catch (err) {
    console.error(err);
  } finally {
    await client.end()
  }
}


functions.cloudEvent('sendEmail', cloudEvent => {

  const base64name = cloudEvent.data.message.data;
  const data = JSON.parse(Buffer.from(base64name, 'base64').toString());

  const { username } = data;
  const token = uuidv4();
  const token_creation_time = new Date()
  const token_expiration_time = new Date(new Date().getTime() + 1000 * 60 * 2)


  // const verificationLink = `http://localhost:8080/v1/user/verify?username=${username}&token=${token}`;
  const verificationLink = `https://sinianliu.me/v1/user/verify?username=${username}&token=${token}`;

  updateDataToUserTable(username, token, token_creation_time, token_expiration_time);
  sendMail(username, verificationLink);
});



// local db config for testing
// const client = new Client({
//   host: 'localhost',
//   user: 'postgres',
//   password: '123456',
//   database: 'webapp',
//   port: 5432,
// });


// local testing
// const test = function () {
//   const username = 'liusinian2021@gmail.com';
//   const token = 1242;
//   const token_creation_time = new Date()
//   const token_expiration_time = new Date(new Date().getTime() + 1000 * 60 * 2)

//   const verificationLink = `http://localhost:8080/v1/user/verify?username=${username}&token=${token}`;
//   //   const verificationLink = `http://sinianliu.me:8080/v1/user/verify?username=${username}&token=${token}`;

//   sendMail(username, verificationLink);
//   updateDataToUserTable(username, token, token_creation_time, token_expiration_time);
// }

// test();
