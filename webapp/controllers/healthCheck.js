const { Pool } = require('pg');

require('dotenv').config();


const pool = new Pool({
  user: process.env.DB_USERNAME,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: 5432,
});


const checkHealthz = (req, res) => {
  if (req.method === 'GET') {
    getHealthz(req, res);
  } else {
    res.set('Cache-Control', 'no-cache');
    res.status(405).end();
  }
};


const getHealthz = (req, res) => {

  if (Object.entries(req.body).length || Object.entries(req.query).length) {
    res.set('Cache-Control', 'no-cache');
    return res.status(400).end();
  }

  pool.query('SELECT NOW()', (err, result) => {
    if (err) {
      // console.log('Error connecting to database');
      res.set('Cache-Control', 'no-cache');
      return res.status(503).end();
    } else {
      // console.log('Successfully connected to database');
      res.set('Cache-Control', 'no-cache');
      return res.status(200).end();
    }
  });
};


module.exports = {
  checkHealthz
}
