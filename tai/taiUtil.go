package tai

import (
	"github.com/ethereum/go-ethereum/log"
	"net/http"
	"io/ioutil"
	"encoding/json"
)

func ListFromUrl(url string) []string{
	resp, err := http.Get(url)
	if err != nil {
		return nil

	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil

	}

	nodelist := []string{}
	if err := json.Unmarshal(body, &nodelist); err != nil {
		log.Error("parse http response failed", "err:", err)
		return nil
	}

	return nodelist
}