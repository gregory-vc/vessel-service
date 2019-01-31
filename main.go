package main

import (
	"fmt"
	"log"

	"os"

	pb "github.com/gregory-vc/vessel-service/proto/vessel"
	"github.com/micro/go-micro"
)

func main() {

	host := os.Getenv("DB_HOST")

	session, err := CreateSession(host)
	defer session.Close()

	if err != nil {
		log.Fatalf("Error connecting to datastore: %v", err)
	}

	srv := micro.NewService(
		micro.Name("go.micro.srv.vessel"),
		micro.Version("latest"),
	)

	srv.Init()

	// Register our implementation with
	pb.RegisterVesselServiceHandler(srv.Server(), &service{session})

	if err := srv.Run(); err != nil {
		fmt.Println(err)
	}
}
