require('dotenv').config();

const app = require('./server');

const PORT = process.env.PORT || 8080;

app.listen(PORT, () => console.log(`Listening on http://localhost:${PORT}`));
