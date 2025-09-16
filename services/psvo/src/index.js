const express = require('express');
const app = express();
const port = 80;

app.get('/', (req, res) => {
  res.send('Hello from Express in a Docker container!');
});

app.listen(port, () => {
  console.log(`Express app listening at http://localhost:${port}`);
});