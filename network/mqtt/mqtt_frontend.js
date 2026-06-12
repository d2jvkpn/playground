// 使用 mqtt.js
const client = mqtt.connect('wss://broker.example.com:8083/mqtt')

client.on('connect', () => {
  console.log('Connected to MQTT broker')
  client.subscribe('factory/line1/temperature')
})

client.on('message', (topic, message) => {
  console.log(`Topic: ${topic}, Message: ${message.toString()}`)
})
