const EventSource = require('eventsource');


const url = 'https://api.example.com/llm/sse-stream';

const eventSource = new EventSource(url, {
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY',
    'Content-Type': 'application/json',
  },
  method: 'POST',
  body: JSON.stringify({ prompt: "Tell me a long story" }),
});

eventSource.onmessage = (event) => {
  console.log(event.data);
};

eventSource.onerror = (error) => {
  console.error('Error:', error);
  eventSource.close();
};
