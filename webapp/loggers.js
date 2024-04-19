
const { createLogger, format, transports } = require('winston');
const { combine, timestamp, json } = format;

const userLogger = createLogger({
  defaultMeta: { component: 'user-service' },
  format: combine(
    timestamp({
      format: 'YYYY-MM-DD HH:mm:ss'
    }),
    json()
  ),

  transports: [
    new transports.Console(),
    new transports.File({ filename: '/tmp/webapp.log' })
  ]
});


const authLogger = createLogger({
  defaultMeta: { component: 'auth-service' },
  format: combine(
    timestamp({
      format: 'YYYY-MM-DD HH:mm:ss'
    }),
    json()
  ),

  transports: [
    new transports.Console(),
    new transports.File({ filename: '/tmp/webapp.log' })
  ]
});


const healthCheckLogger = createLogger({
  defaultMeta: { component: 'healthcheck-service' },
  format: combine(
    timestamp({
      format: 'YYYY-MM-DD HH:mm:ss'
    }),
    json()
  ),
  transports: [
    new transports.Console(),
    new transports.File({ filename: '/tmp/webapp.log' })
  ]
});


module.exports = {
  authLogger,
  healthCheckLogger,
  userLogger
};
