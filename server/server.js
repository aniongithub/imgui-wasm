const express = require('express')
const http = require('http');

const app = express();
const httpServer = http.createServer(app);
app.use('/', express.static('client'));
app.use('/js/imgui.js', express.static('build/imgui.js'));
app.use('/js/imgui.js.mem', express.static('build/imgui.js.mem'));

const port = process.env.PORT || 80;
httpServer.listen(port, () => console.log(`Listening on port ${port}!`));