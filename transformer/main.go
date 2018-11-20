package main

import (
	"fmt"
	"log"
	"os"

	// "github.com/filipovi/elastic"
	"github.com/filipovi/rabbitmq"
)

// ETL in GO
// 1. connect to RMQ
// 2. connect to ES
// 3. on new event -> goroutine
// 4. -> transform event payload in ES

// Env contains the ES & RMQ clients
type Env struct {
	// client  elastic.Client
	channel rabbitmq.Channel
}

// EventMessage represents a Message in RabbitMQ
type EventMessage struct {
	ID        string              `json:"id"`
	ModelType string              `json:"model_type"`
	Event     string              `json:"event"`
	Metadata  map[string][]string `json:"metadata"`
}

func failOnError(err error, msg string) {
	if err == nil {
		return
	}
	log.Fatalf("%s: %s", msg, err)
	panic(fmt.Sprintf("%s: %s", msg, err))
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

func main() {
	url := getEnv("RMQ_URL", "amqp://guest:guest@0.0.0.0:5672/")
	rmq, err := rabbitmq.Connect(url)
	if nil != err {
		panic("Connection error")
	}
	log.Println("RabbitMQ connected!")

	env := &Env{
		channel: *rmq,
	}

	err = env.channel.NewExchange("event_message.mailchimp")
	failOnError(err, "Failed to create an apmq exchange")

	q, err := env.channel.NewQueue("")
	failOnError(err, "Failed to declare a queue")

	err = env.channel.BindQueue(q.Name, "event_message.mailchimp")
	failOnError(err, "Failed to bind a queue")

	msgs, err := env.channel.Consume(
		q.Name, // queue
		"",     // consumer
		true,   // auto-ack
		false,  // exclusive
		false,  // no-local
		false,  // no-wait
		nil,    // args
	)
	failOnError(err, "Failed to register a consumer")

	forever := make(chan bool)
	go func() {
		for d := range msgs {
			log.Printf(" [x] %s", d.Body)
		}
	}()

	log.Printf(" [*] Waiting for logs. To exit press CTRL+C")
	<-forever
}
