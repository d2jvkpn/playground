const axios = require('axios');


async function streamLLMResponse() {
  const response = await axios({
    method: 'post',
    url: 'https://api.example.com/llm/stream',
    headers: {
      'Authorization': 'Bearer YOUR_API_KEY',
      'Content-Type': 'application/json',
    },
    data: { prompt: "Tell me a long story" },
    responseType: 'stream',
  });

  response.data.on('data', (chunk) => {
    process.stdout.write(chunk.toString());
  });

  response.data.on('end', () => {
    console.log('\nStream ended');
  });
}

streamLLMResponse().catch(console.error);
