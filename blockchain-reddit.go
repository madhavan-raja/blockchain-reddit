package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type Subreddit struct {
	SubredditName string `json:"name"`
}

type Post struct {
	PostID        string `json:"id"`
	SubredditName string `json:"subreddit"`
	Title         string `json:"title"`
	Content       string `json:"content"`
}

type RedditContract struct {
	contractapi.Contract
}

func (s *RedditContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	subreddits := []Subreddit{
		{SubredditName: "cats"},
		{SubredditName: "dogs"},
	}

	posts := []Post{
		{PostID: "0", SubredditName: "cats", Title: "Meow", Content: "Cats are the best"},
		{PostID: "1", SubredditName: "dogs", Title: "Woof", Content: "Dogs are the best"},
	}

	for _, subreddit := range subreddits {
		productJSON, err := json.Marshal(subreddit)
		if err != nil {
			return err
		}

		err = ctx.GetStub().PutState(subreddit.SubredditName, productJSON)
		if err != nil {
			return fmt.Errorf("Failed to put to world state. %v", err)
		}
	}

	for _, post := range posts {
		productJSON, err := json.Marshal(post)
		if err != nil {
			return err
		}

		err = ctx.GetStub().PutState(post.PostID, productJSON)
		if err != nil {
			return fmt.Errorf("Failed to put to world state. %v", err)
		}
	}

	return nil
}

func (s *RedditContract) CreateSubreddit(ctx contractapi.TransactionContextInterface, SubredditName string) error {
	exists, err := s.VerifySubreddit(ctx, SubredditName)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("The subreddit %s already exists.", SubredditName)
	}

	subreddit := Subreddit{
		SubredditName: SubredditName,
	}

	subredditJSON, err := json.Marshal(subreddit)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(SubredditName, subredditJSON)
}

func (s *RedditContract) CreatePost(ctx contractapi.TransactionContextInterface, PostID string, SubredditName string, Title string, Content string) error {
	exists, err := s.VerifySubreddit(ctx, SubredditName)
	if err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("The subreddit %s does not exist.", SubredditName)
	}

	post := Post{
		PostID:        PostID,
		SubredditName: SubredditName,
		Title:         Title,
		Content:       Content,
	}

	postJSON, err := json.Marshal(post)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(PostID, postJSON)
}

func (s *RedditContract) UpdatePost(ctx contractapi.TransactionContextInterface, PostID string, NewTitle string, NewContent string) error {
	post, err := s.GetPost(ctx, PostID)
	if err != nil {
		return err
	}

	post.Title = NewTitle
	post.Content = NewContent

	productJSON, err := json.Marshal(post)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(PostID, productJSON)
}

func (s *RedditContract) TransferOwnership(ctx contractapi.TransactionContextInterface, PostID string, NewSubredditName string) error {
	post, err := s.GetPost(ctx, PostID)
	if err != nil {
		return err
	}

	exists, err := s.VerifySubreddit(ctx, NewSubredditName)
	if err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("The subreddit %s does not exist.", NewSubredditName)
	}

	post.SubredditName = NewSubredditName
	productJSON, err := json.Marshal(post)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(PostID, productJSON)
}

func (s *RedditContract) GetPosts(ctx contractapi.TransactionContextInterface) ([]*Post, error) {
	resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var posts []*Post
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var post Post
		err = json.Unmarshal(queryResponse.Value, &post)
		if err != nil {
			return nil, err
		}
		posts = append(posts, &post)
	}

	return posts, nil
}

func (s *RedditContract) VerifySubreddit(ctx contractapi.TransactionContextInterface, SubredditName string) (bool, error) {
	productJSON, err := ctx.GetStub().GetState(SubredditName)
	if err != nil {
		return false, fmt.Errorf("Failed to read from world state: %v", err)
	}
	return productJSON != nil, nil
}

func (s *RedditContract) GetPost(ctx contractapi.TransactionContextInterface, PostID string) (*Post, error) {
	postJSON, err := ctx.GetStub().GetState(PostID)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state: %v", err)
	}
	if postJSON == nil {
		return nil, fmt.Errorf("The post %s does not exist", PostID)
	}

	var post Post
	err = json.Unmarshal(postJSON, &post)
	if err != nil {
		return nil, err
	}

	return &post, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(&RedditContract{})
	if err != nil {
		fmt.Printf("Error creating Reddit chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting Reddit chaincode: %s", err.Error())
	}
}
