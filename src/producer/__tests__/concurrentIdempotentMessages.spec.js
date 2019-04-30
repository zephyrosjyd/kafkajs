const createProducer = require('../')
const createConsumer = require('../../consumer')
const sleep = require('../../utils/sleep')

const {
  secureRandom,
  createCluster,
  createTopic,
  createModPartitioner,
  newLogger,
  waitFor,
  waitForMessages,
  testIfKafka_0_11,
  waitForConsumerToJoinGroup,
  generateMessages,
} = require('testHelpers')

describe('Producer > Idempotent Producer', () => {
  let topicName, groupId, cluster, producer, consumer

  beforeEach(async () => {
    topicName = `test-topic-${secureRandom()}`
    groupId = `consumer-group-id-${secureRandom()}`

    await createTopic({ topic: topicName, partitions: 3 })

    cluster = createCluster({ maxInFlightRequests: 1 })
    producer = createProducer({
      cluster,
      createPartitioner: createModPartitioner,
      logger: newLogger(),
      idempotent: true,
    })

    consumer = createConsumer({
      cluster,
      groupId,
      maxWaitTimeInMs: 100,
      logger: newLogger(),
    })
  })

  afterEach(async () => {
    await consumer.disconnect()
    await producer.disconnect()
  })

  it('should not drop messages when producing concurrently', async () => {
    await consumer.connect()
    await producer.connect()
    await consumer.subscribe({ topic: topicName, fromBeginning: true })

    const messagesConsumed = []
    consumer.run({ eachMessage: async event => messagesConsumed.push(event) })
    await waitForConsumerToJoinGroup(consumer)

    const messages = generateMessages({ number: 10 })

    await Promise.all(
      messages.map(message => producer.send({ topic: topicName, messages: [message] }))
    )

    await waitForMessages(messagesConsumed, { number: messages.length })
  })
})
