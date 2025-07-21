import { createServer } from 'node:http';


const server = createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello World!\n');
});

let port = 3000;
let host = "127.0.0.1"

server.listen(port, host, () => {
  console.log(`==> Listening on ${host}:${port}`);
});
