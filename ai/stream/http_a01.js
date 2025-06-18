const http = require('http');

const options = {
  hostname: 'api.example.com',
  path: '/llm/stream',
  method: 'POST',
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY',
    'Content-Type': 'application/json',
  }
};

const req = http.request(options, (res) => {
  res.setEncoding('utf8');
  
  res.on('data', (chunk) => {
    // 处理流式数据
    process.stdout.write(chunk);
  });
  
  res.on('end', () => {
    console.log('\nStream ended');
  });
});

req.write(JSON.stringify({ prompt: "Tell me a long story" }));
req.end();
