package main

import (
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"time"

	"github.com/rs/zerolog"
)

func main() {

	file, err := os.OpenFile(
        "../elk-deploy/logdata/logData.log",
        os.O_APPEND|os.O_CREATE|os.O_WRONLY,
        0664,
    )
    if err != nil {
        panic(err)
    }

    defer file.Close()

    log := zerolog.New(file)

	createLogs(&log)


}

func createLogs(logger *zerolog.Logger) {
	fmt.Println("STARTING LOG CREATION")
	// Creates a random number generator (used in log creation for severity)
	rngSource := rand.NewSource(time.Now().UnixNano())
	rng := rand.New(rngSource)

	// Runs a loop every second for a minute
	for i := 0; i < 60; i++ {

		// Creates a log payload
		payload := map[string]interface{}{
			"message": "TEST_MSG" + strconv.Itoa(i),
			"error":   false,
		}

		// Generates random number between 0 - 4
		messageType := rng.Intn(4)

		// Sends log with specified severity level
		switch messageType {
		case 0:
			logger.Info().
				Bool("error", payload["error"].(bool)).
				Msg(payload["message"].(string))
		case 1:
			logger.Debug().
				Bool("error", payload["error"].(bool)).
				Msg(payload["message"].(string))
		case 2:
			logger.Warn().
				Bool("error", payload["error"].(bool)).
				Msg(payload["message"].(string))
		case 3:
			payload["error"] = true
			logger.Error().
				Bool("error", payload["error"].(bool)).
				Msg(payload["message"].(string))
		}

		time.Sleep(time.Second)

	}
}